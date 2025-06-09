# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: qt6-build.eclass
# @MAINTAINER:
# qt@gentoo.org
# @SUPPORTED_EAPIS: 8
# @PROVIDES: cmake
# @BLURB: Eclass for Qt6 split ebuilds.
# @DESCRIPTION:
# This eclass contains various functions that are used when building Qt6.

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_QT6_BUILD_ECLASS} ]]; then
_QT6_BUILD_ECLASS=1

[[ ${CATEGORY} != dev-qt ]] &&
	die "${ECLASS} is only to be used for building Qt6"

inherit cmake flag-o-matic toolchain-funcs
[[ ${EAPI} == 8 ]] && inherit eapi9-pipestatus
[[ ${QT6_HAS_STATIC_LIBS} ]] && inherit dot-a

# @ECLASS_VARIABLE: QT6_BUILD_TYPE
# @DESCRIPTION:
# Read only variable set based on PV to one of:
#  - release: official 6.x.x releases
#  - pre-release: development 6.x.x_rc/beta/alpha releases
#  - live: *.9999 (dev branch), 6.x.9999 (stable branch)

# @ECLASS_VARIABLE: QT6_MODULE
# @PRE_INHERIT
# @DESCRIPTION:
# The upstream name of the module this package belongs to.
# Used for SRC_URI and EGIT_REPO_URI.
: "${QT6_MODULE:=${PN}}"

# @ECLASS_VARIABLE: QT6_HAS_STATIC_LIBS
# @DEFAULT_UNSET
# @PRE_INHERIT
# @DESCRIPTION:
# Should be set to a non-empty value if static libraries may be
# installed so that dot-a.eclass will be used.  Using either way
# is mostly harmless but still a bit wasteful, thus the variable.

# @ECLASS_VARIABLE: QT6_RESTRICT_TESTS
# @DEFAULT_UNSET
# @PRE_INHERIT
# @DESCRIPTION:
# If set to a non-empty value, will not add IUSE="test" and set
# RESTRICT="test" instead.  Primarily intended for ebuilds where
# running tests is unmaintained (or missing) rather than just
# temporarily restricted not to have a broken USE (bug #930266).

if [[ ${PV} == *.9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI=(
		"https://code.qt.io/qt/${QT6_MODULE}.git"
		"https://github.com/qt/${QT6_MODULE}.git"
	)

	QT6_BUILD_TYPE=live
	EGIT_BRANCH=dev
	[[ ${PV} == 6.*.9999 ]] && EGIT_BRANCH=${PV%.9999}
else
	QT6_BUILD_TYPE=release
	_QT6_SRC=official

	if [[ ${PV} == *_@(alpha|beta|rc)* ]]; then
		QT6_BUILD_TYPE=pre-release
		_QT6_SRC=development
	fi

	_QT6_P=${QT6_MODULE}-everywhere-src-${PV/_/-}
	SRC_URI="https://download.qt.io/${_QT6_SRC}_releases/qt/${PV%.*}/${PV/_/-}/submodules/${_QT6_P}.tar.xz"
	S=${WORKDIR}/${_QT6_P}

	unset _QT6_P _QT6_SRC
fi
readonly QT6_BUILD_TYPE

HOMEPAGE="https://www.qt.io/"
LICENSE="|| ( GPL-2 GPL-3 LGPL-3 ) FDL-1.3"
SLOT="6/${PV%%_*}"
IUSE="custom-cflags"

if [[ ${QT6_RESTRICT_TESTS} ]]; then
	RESTRICT="test"
else
	IUSE+=" test"
	RESTRICT="!test? ( test )"
fi

BDEPEND="
	dev-lang/perl
	virtual/pkgconfig
"

######  Phase functions  ######

# @FUNCTION: qt6-build_src_unpack
# @DESCRIPTION:
# Run git-r3_src_unpack if needed (live), then default to unpack
# e.g. patchsets in live ebuilds.
qt6-build_src_unpack() {
	[[ ${QT6_BUILD_TYPE} == live ]] && git-r3_src_unpack

	default
}

# @FUNCTION: qt6-build_src_prepare
# @DESCRIPTION:
# Run cmake_src_prepare, prepare the environment (such as set
# QT6_PREFIX, QT6_LIBDIR, and others), and handle anything else
# generic as needed.
qt6-build_src_prepare() {
	cmake_src_prepare

	if [[ -e CMakeLists.txt ]]; then
		# throw an error rather than skip if *required* conditions are not met
		sed -e '/message(NOTICE.*Skipping/s/NOTICE/FATAL_ERROR/' \
			-i CMakeLists.txt || die
	fi

	if in_iuse test && use test && [[ -e tests/auto/CMakeLists.txt ]]; then
		# .cmake files tests causing a self-dependency in many modules,
		# and that sometimes install additional test junk
		sed -i '/add_subdirectory(cmake)/d' tests/auto/CMakeLists.txt || die
	fi

	_qt6-build_prepare_env

	if use !custom-cflags; then
		_qt6-build_sanitize_cpu_flags

		# LTO cause test failures in several components (qtcharts,
		# multimedia, scxml, wayland, webchannel, and likely more --
		# also 1 qtbase test wrt bug #955531), albeit many need
		# retesting (not as bad as it used to). Many (all?) of these
		# issues only happen with GCC.
		filter-lto
	fi

	[[ ${QT6_HAS_STATIC_LIBS} ]] && lto-guarantee-fat
}

# @FUNCTION: qt6-build_src_configure
# @DESCRIPTION:
# Run cmake_src_configure and handle anything else generic as needed.
qt6-build_src_configure() {
	if [[ ${PN} == qttranslations ]]; then
		# does not compile anything, further options would be unrecognized
		cmake_src_configure
		return
	fi

	local defaultcmakeargs=(
		# cmake defaults to "STATUS" but Qt changes that to "NOTICE" which
		# hides a lot of information that is useful for bug reports
		--log-level=STATUS
		# ...but dev messages are noisy and not really useful downstream
		-Wno-dev
		# see _qt6-build_create_user_facing_links
		-DINSTALL_PUBLICBINDIR="${QT6_PREFIX}"/bin
		# note that if qtbase was built with tests, this is default ON
		-DQT_BUILD_TESTS=$(in_iuse test && use test && echo ON || echo OFF)
		# avoid appending -O2 after user's C(XX)FLAGS (bug #911822)
		-DQT_USE_DEFAULT_CMAKE_OPTIMIZATION_FLAGS=ON
	)

	if [[ ${mycmakeargs@a} == *a* ]]; then
		local mycmakeargs=("${defaultcmakeargs[@]}" "${mycmakeargs[@]}")
	else
		local mycmakeargs=("${defaultcmakeargs[@]}")
	fi

	# Qt has quite a lot of unused (false positive) CMakeLists.txt
	local CMAKE_QA_COMPAT_SKIP=1

	cmake_src_configure
}

# @FUNCTION: qt6-build_src_test
# @USAGE: [<cmake_src_test argument>...]
# @DESCRIPTION:
# Run cmake_src_test and handle anything else generic as-needed.
qt6-build_src_test() {
	local -x QML_IMPORT_PATH=${BUILD_DIR}${QT6_QMLDIR#"${QT6_PREFIX}"}
	local -x QTEST_FUNCTION_TIMEOUT=900000 #914737
	local -x QT_QPA_PLATFORM=offscreen

	# TODO?: CMAKE_SKIP_TESTS skips a whole group of tests and, when
	# only want to skip a sepcific sub-test, the BLACKLIST files
	# could potentially be modified by implementing a QT6_SKIP_TESTS

	cmake_src_test "${@}"
}

# @FUNCTION: qt6-build_src_install
# @DESCRIPTION:
# Run cmake_src_install and handle anything else generic as needed.
qt6-build_src_install() {
	cmake_src_install

	[[ ${QT6_HAS_STATIC_LIBS} ]] && strip-lto-bytecode "${D}${QT6_LIBDIR}"

	_qt6-build_create_user_facing_links

	# Qt often install unwanted files when tests are enabled and, while
	# this does not cover everything, delete the common case.
	rm -rf -- "${D}${QT6_PREFIX}"/tests || die
}

######  Public helpers  ######

# @FUNCTION: qt_feature
# @USAGE: <flag> [feature]
# @DESCRIPTION:
# <flag> is the name of a flag in IUSE.
qt_feature() {
	[[ ${#} -ge 1 ]] || die "${FUNCNAME}() requires at least one argument"

	echo "-DQT_FEATURE_${2:-${1}}=$(usex ${1} ON OFF)"
}

######  Internal functions  ######

# @FUNCTION: _qt6-build_create_user_facing_links
# @INTERNAL
# @DESCRIPTION:
# Create links for user facing tools (bug #863395) as suggested in:
# https://doc.qt.io/qt-6/packaging-recommendations.html
_qt6-build_create_user_facing_links() {
	# user_facing_tool_links.txt is always created (except for qttranslations)
	# even if no links (empty), if missing will assume that it is an error
	[[ ${PN} == qttranslations ]] && return

	local link
	while IFS= read -r link; do
		if [[ -z ${link} ]]; then
			continue
		elif [[ ${link} =~ (../[^ ]+)\ (bin/.+) ]]; then
			dosym "${BASH_REMATCH[1]}" \
				"${QT6_PREFIX#"${EPREFIX}"}/${BASH_REMATCH[2]}"
		else
			die "unrecognized user_facing_tool_links.txt line: ${link}"
		fi
	done < "${BUILD_DIR}"/user_facing_tool_links.txt || die
}

# @FUNCTION: _qt6-build_prepare_env
# @INTERNAL
# @DESCRIPTION:
# Prepares the environment for building Qt.
_qt6-build_prepare_env() {
	# setup installation directories
	# note: keep paths in sync with qmake-utils.eclass
	readonly QT6_PREFIX=${EPREFIX}/usr
	readonly QT6_DATADIR=${QT6_PREFIX}/share/qt6
	readonly QT6_LIBDIR=${QT6_PREFIX}/$(get_libdir)

	readonly QT6_ARCHDATADIR=${QT6_LIBDIR}/qt6

	readonly QT6_BINDIR=${QT6_ARCHDATADIR}/bin
	readonly QT6_DOCDIR=${QT6_PREFIX}/share/qt6-doc
	readonly QT6_EXAMPLESDIR=${QT6_DATADIR}/examples
	readonly QT6_HEADERDIR=${QT6_PREFIX}/include/qt6
	readonly QT6_IMPORTDIR=${QT6_ARCHDATADIR}/imports
	readonly QT6_LIBEXECDIR=${QT6_ARCHDATADIR}/libexec
	readonly QT6_MKSPECSDIR=${QT6_ARCHDATADIR}/mkspecs
	readonly QT6_PLUGINDIR=${QT6_ARCHDATADIR}/plugins
	readonly QT6_QMLDIR=${QT6_ARCHDATADIR}/qml
	readonly QT6_SYSCONFDIR=${EPREFIX}/etc/xdg
	readonly QT6_TRANSLATIONDIR=${QT6_DATADIR}/translations
}

# @FUNCTION: _qt6-build_sanitize_cpu_flags
# @INTERNAL
# @DESCRIPTION:
# Qt hardly supports use of -mno-* or -march=native for unusual CPUs
# (or VMs) that support incomplete x86-64 feature levels among other
# issues such as CPUs with buggy rdrand, and attempts to allow this
# anyway has worked poorly.  This strips CPU instructions related
# -m* flags and replaces with the highest -march=x86-64-v* usable as
# a non-ideal solution (bug #898644,#908420,#913400,#922498,#933374).
_qt6-build_sanitize_cpu_flags() {
	# less of an issue with non-amd64, will revisit only if needed
	use amd64 || return 0

	local cpuflags=(
		# ideally update whenever compilers gain new ones, or could
		# be offloaded to flag-o-matic if needed by other ebuilds
		# grep -B 1 'Var(ix86_isa_flags' gcc/config/i386/i386.opt | grep ^m | grep -Ev '^m(16|32|64|x32)'
		3dnow 3dnowa abm adx aes amx-avx512 amx-bf16 amx-complex
		amx-fp16 amx-fp8 amx-int8 amx-movrs amx-tf32 amx-tile
		amx-transpose apxf avx avx10.1-256 avx10.1-512 avx10.2-256
		avx10.2-512 avx2 avx512bf16 avx512bitalg avx512bw avx512cd
		avx512dq avx512f avx512fp16 avx512ifma avx512vbmi avx512vbmi2
		avx512vl avx512vnni avx512vp2intersect avx512vpopcntdq avxifma
		avxneconvert avxvnni avxvnniint16 avxvnniint8 bmi bmi2 cldemote
		clflushopt clwb clzero cmpccxadd crc32 cx16 enqcmd evex512 f16c
		fma fma4 fsgsbase fxsr gfni hle hreset kl lwp lzcnt mmx movbe
		movdir64b movdiri movrs mwait mwaitx pclmul pconfig pku popcnt
		prefetchi prfchw ptwrite raoint rdpid rdrnd rdseed rtm sahf
		serialize sgx sha sha512 shstk sm3 sm4 sse sse2 sse3 sse4
		sse4.1 sse4.2 sse4a ssse3 tbm tsxldtrk uintr usermsr vaes
		vpclmulqdq waitpkg wbnoinvd widekl xop xsave xsavec xsaveopt
		xsaves
	)

	# determine and the highest(known) usable x86-64 feature level
	# so users will not lose *all* CPU-specific optimizations
	local march=$(
		$(tc-getCXX) -E -P ${CXXFLAGS} ${CPPFLAGS} - <<-EOF | tail -n 1
			default
			#if (__CRC32__ + __LAHF_SAHF__ + __POPCNT__ + __SSE3__ + __SSE4_1__ + __SSE4_2__ + __SSSE3__) == 7
			x86-64-v2
			#  if (__AVX__ + __AVX2__ + __BMI__ + __BMI2__ + __F16C__ + __FMA__ + __LZCNT__ + __MOVBE__ + __XSAVE__) == 9
			x86-64-v3
			#    if !defined(__EVEX512__) && !defined(__clang__) && __GNUC__ >= 16
			#      define __EVEX512__ 1 /* removed in gcc-16 (bug #956750) */
			#    endif
			#    if (__AVX512BW__ + __AVX512CD__ + __AVX512DQ__ + __AVX512F__ + __AVX512VL__ + __EVEX256__ + __EVEX512__) == 7
			x86-64-v4
			#    endif
			#  endif
			#endif
		EOF
		pipestatus || die
	)

	filter-flags '-march=*' "${cpuflags[@]/#/-m}" "${cpuflags[@]/#/-mno-}"
	[[ ${march} == x86-64* ]] && append-flags $(test-flags-CXX -march="${march}")
	einfo "C(XX)FLAGS adjusted due to frequent -march=*/-m* issues with Qt:"
	einfo "    \"${CXXFLAGS}\""
	einfo "(can override with USE=custom-cflags, but no support will be given)"
}

fi

EXPORT_FUNCTIONS src_unpack src_prepare src_configure src_test src_install
