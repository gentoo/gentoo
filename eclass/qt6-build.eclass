# Copyright 2021-2023 Gentoo Authors
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

# @ECLASS_VARIABLE: QT6_MODULE
# @PRE_INHERIT
# @DESCRIPTION:
# The upstream name of the module this package belongs to.
# Used for SRC_URI and EGIT_REPO_URI.
: "${QT6_MODULE:=${PN}}"

# @ECLASS_VARIABLE: QT6_BUILD_TYPE
# @DESCRIPTION:
# Read only variable set based on PV to one of:
#  - release: official 6.x.x releases
#  - pre-release: development 6.x.x_rc/beta/alpha releases
#  - live: *.9999 (dev branch), 6.x.9999 (stable branch)

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
SLOT=6/${PV%%_*}

if [[ ${PN} != qttranslations ]]; then
	IUSE="test"
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
	_qt6-build_match_cpu_flags

	# LTO cause test failures in several components (e.g. qtcharts,
	# multimedia, scxml, wayland, webchannel, ...).
	#
	# Exact extent/causes unknown, but for some related-sounding bugs:
	# https://bugreports.qt.io/browse/QTBUG-112332
	# https://bugreports.qt.io/browse/QTBUG-115731
	#
	# Does not manifest itself with clang:16 (did with gcc-13.2.0), but
	# still assumed to be generally unsafe either way in current state.
	in_iuse custom-cflags && use custom-cflags || filter-lto
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
		# see _qt6-build_create_user_facing_links
		-DINSTALL_PUBLICBINDIR="${QT6_PREFIX}"/bin
		# note that if qtbase was built with tests, this is default ON
		-DQT_BUILD_TESTS=$(usex test ON OFF)
		# avoid appending -O2 after user's C(XX)FLAGS (bug #911822)
		-DQT_USE_DEFAULT_CMAKE_OPTIMIZATION_FLAGS=ON
	)

	if [[ ${mycmakeargs@a} == *a* ]]; then
		local mycmakeargs=("${defaultcmakeargs[@]}" "${mycmakeargs[@]}")
	else
		local mycmakeargs=("${defaultcmakeargs[@]}")
	fi

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

	_qt6-build_create_user_facing_links

	# hack: trim typical junk with currently no known "proper" way
	# to avoid that primarily happens with tests (e.g. qt5compat and
	# qtsvg tests, but qtbase[gui,-test] currently does some too)
	rm -rf -- "${D}${QT6_PREFIX}"/tests \
		"${D}${QT6_LIBDIR}/objects-${CMAKE_BUILD_TYPE}" || die
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

# @FUNCTION: qt6_symlink_binary_to_path
# @USAGE: <target binary name> [suffix]
# @DESCRIPTION:
# Symlink a given binary from QT6_BINDIR to QT6_PREFIX/bin, with
# optional suffix.
#
# Note: deprecated, will be removed when no consumers left in-tree,
# see internal the _qt6-build_create_user_facing_links
qt6_symlink_binary_to_path() {
	[[ ${#} -ge 1 ]] || die "${FUNCNAME}() requires at least one argument"

	dosym -r "${QT6_BINDIR}"/${1} /usr/bin/${1}${2}
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

	# loop and match using paths (upstream suggests `xargs ln -s < ${links}`
	# but, for what it is worth, that will fail if paths have spaces)
	local link
	while IFS= read -r link; do
		if [[ -z ${link} ]]; then
			continue
		elif [[ ${link} =~ ^("${QT6_PREFIX}"/.+)\ ("${QT6_PREFIX}"/bin/.+) ]]
		then
			dosym -r "${BASH_REMATCH[1]#"${EPREFIX}"}" \
				"${BASH_REMATCH[2]#"${EPREFIX}"}"
		else
			die "unrecognized line '${link}' in '${links}'"
		fi
	done < "${BUILD_DIR}"/user_facing_tool_links.txt || die
}

# @FUNCTION: _qt6-build_match_cpu_flags
# @INTERNAL
# @DESCRIPTION:
# Try to adjust -m* cpu CXXFLAGS so that they match a configuration
# accepted by Qt's headers, see bug #908420.
_qt6-build_match_cpu_flags() {
	use amd64 || use x86 || return 0

	local flags=() intrin intrins
	while IFS=' ' read -ra intrins; do
		[[ ${intrins[*]} == *=[^_]* && ${intrins[*]} == *=_* ]] &&
			for intrin in "${intrins[@]%=*}"; do
				[[ ${intrin} ]] && flags+=( -mno-${intrin} )
			done
	done < <(
		$(tc-getCXX) -E -P ${CXXFLAGS} ${CPPFLAGS} - <<-EOF | tail -n 2
			#if defined(__GNUC__) && (defined(__x86_64__) || defined(__i386__))
			#include <x86intrin.h>
			#endif
			avx2=__AVX2__ =__BMI__ =__BMI2__ =__F16C__ =__FMA__ =__LZCNT__ =__POPCNT__
			avx512f=__AVX512F__ avx512bw=__AVX512BW__ avx512cd=__AVX512CD__ avx512dq=__AVX512DQ__ avx512vl=__AVX512VL__
		EOF
		assert
	)

	if (( ${#flags[@]} )); then
		einfo "Adjusting CXXFLAGS for https://bugs.gentoo.org/908420 with: ${flags[*]}"
		append-cxxflags "${flags[@]}"
	fi
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

fi

EXPORT_FUNCTIONS src_unpack src_prepare src_configure src_test src_install
