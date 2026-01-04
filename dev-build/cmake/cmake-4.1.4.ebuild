# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Generate using https://github.com/thesamesam/sam-gentoo-scripts/blob/main/niche/generate-cmake-docs
# Set to 1 if prebuilt, 0 if not
# (the construct below is to allow overriding from env for script)
: ${CMAKE_DOCS_PREBUILT:=1}

CMAKE_DOCS_PREBUILT_DEV=sam
CMAKE_DOCS_VERSION=4.0.0_rc1
#CMAKE_DOCS_VERSION=${PV}
#CMAKE_DOCS_VERSION=$(ver_cut 1-2).0
# Default to generating docs (inc. man pages) if no prebuilt; overridden later
# See bug #784815
CMAKE_DOCS_USEFLAG="+doc"

CMAKE_QA_COMPAT_SKIP=1 # bug #964514; cmake itself is the last pkg we worry about

# TODO RunCMake.LinkWhatYouUse fails consistently w/ ninja
# ... but seems fine as of 3.22.3?
# TODO ... but bootstrap sometimes(?) fails with ninja now. bug #834759.
CMAKE_MAKEFILE_GENERATOR="emake"
CMAKE_REMOVE_MODULES_LIST=( none )
inherit bash-completion-r1 cmake flag-o-matic multiprocessing \
	toolchain-funcs xdg-utils

MY_P="${P/_/-}"

DESCRIPTION="Cross platform Make"
HOMEPAGE="https://cmake.org/"
if [[ ${PV} == *9999* ]] ; then
	CMAKE_DOCS_PREBUILT=0

	EGIT_REPO_URI="https://gitlab.kitware.com/cmake/cmake.git"
	inherit git-r3
else
	SRC_URI="https://cmake.org/files/v$(ver_cut 1-2)/${MY_P}.tar.gz"

	if [[ ${CMAKE_DOCS_PREBUILT} == 1 ]] ; then
		SRC_URI+=" !doc? ( https://dev.gentoo.org/~${CMAKE_DOCS_PREBUILT_DEV}/distfiles/${CATEGORY}/${PN}/${PN}-${CMAKE_DOCS_VERSION}-docs.tar.xz )"
	fi

	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/bradking.asc
	inherit verify-sig

	SRC_URI+=" verify-sig? (
		https://cmake.org/files/v$(ver_cut 1-2)/${MY_P}-SHA-256.txt
		https://cmake.org/files/v$(ver_cut 1-2)/${MY_P}-SHA-256.txt.asc
		https://github.com/Kitware/CMake/releases/download/v${PV/_/-}/${MY_P}-SHA-256.txt
		https://github.com/Kitware/CMake/releases/download/v${PV/_/-}/${MY_P}-SHA-256.txt.asc
	)"

	if [[ ${PV} != *_rc* ]] ; then
		KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
	fi

	BDEPEND="verify-sig? ( >=sec-keys/openpgp-keys-bradking-20250904 )"
fi

[[ ${CMAKE_DOCS_PREBUILT} == 1 ]] && CMAKE_DOCS_USEFLAG="doc"

S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
IUSE="${CMAKE_DOCS_USEFLAG} dap gui ncurses test"
RESTRICT="!test? ( test )"

# >= 1.51.0-r1 for ppc32 workaround (bug #941738)
RDEPEND="
	>=app-arch/libarchive-3.3.3:=
	app-crypt/rhash:0=
	>=dev-libs/expat-2.0.1
	>=dev-libs/jsoncpp-1.9.2-r2:0=
	>=dev-libs/libuv-1.51.0-r1:=
	>=net-misc/curl-7.21.5[ssl]
	virtual/zlib:=
	virtual/pkgconfig
	dap? ( dev-cpp/cppdap )
	gui? ( dev-qt/qtbase:6[gui,widgets] )
	ncurses? ( sys-libs/ncurses:= )
"
DEPEND="${RDEPEND}"
BDEPEND+="
	doc? (
		dev-python/requests
		dev-python/sphinx
	)
	test? ( app-arch/libarchive[zstd] )
"

SITEFILE="50${PN}-gentoo.el"

PATCHES=(
	# Prefix
	"${FILESDIR}"/${PN}-3.27.0_rc1-0001-Don-t-use-.so-for-modules-on-darwin-macos.-Use-.bund.patch
	"${FILESDIR}"/${PN}-3.27.0_rc1-0002-Set-some-proper-paths-to-make-cmake-find-our-tools.patch
	# Misc
	"${FILESDIR}"/${PN}-3.31.6-Prefer-pkgconfig-in-FindBLAS.patch
	"${FILESDIR}"/${PN}-3.27.0_rc1-0004-Ensure-that-the-correct-version-of-Qt-is-always-used.patch
	"${FILESDIR}"/${PN}-3.27.0_rc1-0005-Respect-Gentoo-s-Python-eclasses.patch
	# Cuda
	"${FILESDIR}/${PN}-3.30.3-cudahostld.patch"

	# Upstream fixes (can usually be removed with a version bump)
)

cmake_src_bootstrap() {
	# disable running of cmake in bootstrap command
	sed -i \
		-e '/"${cmake_bootstrap_dir}\/cmake"/s/^/#DONOTRUN /' \
		bootstrap || die "sed failed"

	# execinfo.h on Solaris isn't quite what it is on Darwin
	if [[ ${CHOST} == *-solaris* ]] ; then
		sed -i -e 's/execinfo\.h/blablabla.h/' \
			Source/kwsys/CMakeLists.txt || die
	fi

	# bootstrap script isn't exactly /bin/sh compatible
	tc-env_build ${CONFIG_SHELL:-sh} ./bootstrap \
		--prefix="${T}/cmakestrap/" \
		--parallel=$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)") \
		|| die "Bootstrap failed"
}

pkg_pretend() {
	if [[ -z ${EPREFIX} ]] ; then
		local file
		local errant_files=()

		# See bug #599684 and bug #753581 (at least)
		for file in /etc/arch-release /etc/redhat-release /etc/debian_version ; do
			if [[ -e ${file} ]]; then
				errant_files+=( "${file}" )
			fi
		done

		# If errant files exist
		if [[ ${#errant_files[@]} -gt 0 ]]; then
			eerror "Errant files found!"
			eerror "The presence of these files is known to confuse CMake's"
			eerror "library path logic. Please (re)move these files:"

			for file in "${errant_files[@]}"; do
				eerror " mv ${file} ${file}.bak"
			done

			die "Stray files found in /etc/, see above message"
		fi
	fi
}

src_unpack() {
	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack
	elif [[ ${PV} == *_rc* ]] || ! use verify-sig ; then
		default
	else
		cd "${DISTDIR}" || die

		# See https://mgorny.pl/articles/verify-sig-by-example.html#verifying-using-a-checksum-file-with-a-detached-signature
		verify-sig_verify_detached ${MY_P}-SHA-256.txt{,.asc}
		verify-sig_verify_unsigned_checksums ${MY_P}-SHA-256.txt sha256 ${MY_P}.tar.gz

		cd "${WORKDIR}" || die

		default
	fi
}

src_prepare() {
	cmake_src_prepare

	if [[ ${CHOST} == *-darwin* ]] ; then
		# Disable Xcode hooks, bug #652134
		sed -i -e 's/cm\(\|Global\|Local\)XCode[^.]\+\.\(cxx\|h\)//' \
			Source/CMakeLists.txt || die
		sed -i -e '/define CMAKE_USE_XCODE/s/XCODE/NO_XCODE/' \
			-e '/cmGlobalXCodeGenerator.h/d' \
			Source/cmake.cxx || die
		# Disable system integration, bug #933744
		sed -i -e 's/__APPLE__/__DISABLED__/' \
			Source/cmFindProgramCommand.cxx \
			Source/CPack/cmCPackGeneratorFactory.cxx || die
		sed -i -e 's/__MAC_OS_X_VERSION_MIN_REQUIRED/__DISABLED__/' \
			Source/cmMachO.cxx || die
		sed -i -e 's:CPack/cmCPack\(Bundle\|DragNDrop\|PKG\|ProductBuild\)Generator.cxx::' \
			Source/CMakeLists.txt || die

		# Disable isysroot usage with GCC, we've properly instructed
		# where things are via GCC configuration and ldwrapper
		sed -i -e '/cmake_gnu_set_sysroot_flag/d' \
			Modules/Platform/Apple-GNU-*.cmake || die
		# Disable isysroot usage with clang as well
		sed -i -e '/_SYSROOT_FLAG/d' \
			Modules/Platform/Apple-Clang.cmake || die
		# Don't set a POSIX standard, system headers don't like that, #757426
		sed -i -e 's/^#if !defined(_WIN32) && !defined(__sun)/& \&\& !defined(__APPLE__)/' \
			Source/cmLoadCommandCommand.cxx \
			Source/cmStandardLexer.h \
			Source/cmSystemTools.cxx \
			Source/cmTimestamp.cxx
		sed -i -e 's/^#if !defined(_POSIX_C_SOURCE) && !defined(_WIN32) && !defined(__sun)/& \&\& !defined(__APPLE__)/' \
			Source/cmStandardLexer.h
	fi

	# Add gcc libs to the default link paths
	sed -i \
		-e "s|@GENTOO_PORTAGE_GCCLIBDIR@|${EPREFIX}/usr/${CHOST}/lib/|g" \
		-e "$(usex prefix-guest "s|@GENTOO_HOST@||" "/@GENTOO_HOST@/d")" \
		-e "s|@GENTOO_PORTAGE_EPREFIX@|${EPREFIX}/|g" \
		Modules/Platform/{UnixPaths,Darwin}.cmake || die "sed failed"

	## in theory we could handle these flags in src_configure, as we do in many other packages. But we *must*
	## handle them as part of bootstrapping, sadly.

	# Fix linking on Solaris
	[[ ${CHOST} == *-solaris* ]] && append-ldflags -lsocket -lnsl

	# ODR warnings, bug #858335
	# https://gitlab.kitware.com/cmake/cmake/-/issues/20740
	filter-lto

	# 4.0.0_rc1 is missing this, fails to configure
	# https://gitlab.kitware.com/cmake/cmake/-/issues/26712
	touch .clang-tidy Utilities/.clang-tidy || die

	if ! has_version -b \>=${CATEGORY}/${PN}-3.13 || ! cmake --version &>/dev/null ; then
		CMAKE_BINARY="${S}/Bootstrap.cmk/cmake"
		cmake_src_bootstrap
	fi
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_USE_SYSTEM_LIBRARIES=ON
		-DCMake_ENABLE_DEBUGGER=$(usex dap)
		-DCMAKE_DOC_DIR=/share/doc/${PF}
		-DCMAKE_MAN_DIR=/share/man
		-DCMAKE_DATA_DIR=/share/${PN}
		-DSPHINX_MAN=$(usex doc)
		-DSPHINX_HTML=$(usex doc)
		-DBUILD_CursesDialog="$(usex ncurses)"
		-DBUILD_TESTING=$(usex test)
		-DBUILD_QtDialog=$(usex gui)
	)

	use gui && mycmakeargs+=( -DCMake_QT_MAJOR_VERSION=6 )

	cmake_src_configure
}

src_test() {
	# Fix OutDir and SelectLibraryConfigurations tests
	# these are altered thanks to our eclass
	sed -i -e 's:^#_cmake_modify_IGNORE ::g' \
		"${S}"/Tests/{OutDir,CMakeOnly/SelectLibraryConfigurations}/CMakeLists.txt \
		|| die

	unset CLICOLOR CLICOLOR_FORCE CMAKE_COMPILER_COLOR_DIAGNOSTICS CMAKE_COLOR_DIAGNOSTICS

	pushd "${BUILD_DIR}" > /dev/null || die

	# Excluded tests:
	#    BootstrapTest: we actually bootstrap it every time so why test it?
	#    BundleUtilities: bundle creation broken
	#    CMakeOnly.AllFindModules: pthread issues
	#    CTest.updatecvs: which fails to commit as root
	#    Fortran: requires fortran
	#    RunCMake.CompilerLauncher: also requires fortran
	#    RunCMake.CPack_RPM: breaks if app-arch/rpm is installed because
	#        debugedit binary is not in the expected location
	#    RunCMake.CPack_DEB: breaks if app-arch/dpkg is installed because
	#        it can't find a deb package that owns libc
	#    TestUpload, which requires network access
	#    RunCMake.CMP0125, known failure reported upstream (bug #829414)
	local myctestargs=(
		--output-on-failure
		-E "(BootstrapTest|BundleUtilities|CMakeOnly.AllFindModules|CompileOptions|CTest.UpdateCVS|Fortran|RunCMake.CompilerLauncher|RunCMake.CPack_(DEB|RPM)|TestUpload|RunCMake.CMP0125)" \
	)

	local -x QT_QPA_PLATFORM=offscreen

	cmake_src_test
}

src_install() {
	cmake_src_install

	# If USE=doc, there'll be newly generated docs which we install instead.
	if ! use doc && [[ ${CMAKE_DOCS_PREBUILT} == 1 ]] ; then
		doman "${WORKDIR}"/${PN}-${CMAKE_DOCS_VERSION}-docs/man*/*.[0-8]
	fi

	insinto /usr/share/vim/vimfiles/syntax
	doins Auxiliary/vim/syntax/cmake.vim

	insinto /usr/share/vim/vimfiles/indent
	doins Auxiliary/vim/indent/cmake.vim

	insinto /usr/share/vim/vimfiles/ftdetect
	doins "${FILESDIR}/${PN}.vim"

	dobashcomp Auxiliary/bash-completion/{${PN},ctest,cpack}
}

pkg_postinst() {
	if use gui; then
		xdg_icon_cache_update
		xdg_desktop_database_update
		xdg_mimeinfo_database_update
	fi
}

pkg_postrm() {
	if use gui; then
		xdg_icon_cache_update
		xdg_desktop_database_update
		xdg_mimeinfo_database_update
	fi
}
