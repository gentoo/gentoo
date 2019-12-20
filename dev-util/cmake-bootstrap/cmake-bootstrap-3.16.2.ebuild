# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR="emake"
CMAKE_REMOVE_MODULES="no"
inherit flag-o-matic multiprocessing toolchain-funcs cmake-utils

MY_P="cmake-${PV/_/-}"

DESCRIPTION="Minimal bootstrap version of CMake"
HOMEPAGE="https://cmake.org/"
SRC_URI="https://cmake.org/files/v$(ver_cut 1-2)/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="CMake"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	app-crypt/rhash
	>=app-arch/libarchive-3.0.0:=
	>=dev-libs/expat-2.0.1
	>=dev-libs/libuv-1.10.0:=
	>=net-misc/curl-7.21.5[ssl]
	sys-libs/zlib
	virtual/pkgconfig
"
DEPEND="${RDEPEND}"

PATCHES=(
	# prefix
	"${FILESDIR}"/cmake-3.16.0_rc4-darwin-bundle.patch
	"${FILESDIR}"/cmake-3.14.0_rc3-prefix-dirs.patch
)

cmake_src_bootstrap() {
	# disable running of cmake in boostrap command
	sed -i \
		-e '/"${cmake_bootstrap_dir}\/cmake"/s/^/#DONOTRUN /' \
		bootstrap || die "sed failed"

	# execinfo.h on Solaris isn't quite what it is on Darwin
	if [[ ${CHOST} == *-solaris* ]] ; then
		sed -i -e 's/execinfo\.h/blablabla.h/' \
			Source/kwsys/CMakeLists.txt || die
	fi

	tc-export CC CXX LD

	# bootstrap script isn't exactly /bin/sh compatible
	${CONFIG_SHELL:-sh} ./bootstrap \
		--prefix="${T}/cmakestrap/" \
		--parallel=$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)") \
		|| die "Bootstrap failed"
}

src_prepare() {
	cmake-utils_src_prepare

	# disable Xcode hooks, bug #652134
	if [[ ${CHOST} == *-darwin* ]] ; then
		sed -i -e 's/__APPLE__/__DISABLED_APPLE__/' \
			Source/cmGlobalXCodeGenerator.cxx || die
	fi

	# Add gcc libs to the default link paths
	sed -i \
		-e "s|@GENTOO_PORTAGE_GCCLIBDIR@|${EPREFIX}/usr/${CHOST}/lib/|g" \
		-e "$(usex prefix-guest "s|@GENTOO_HOST@||" "/@GENTOO_HOST@/d")" \
		-e "s|@GENTOO_PORTAGE_EPREFIX@|${EPREFIX}/|g" \
		Modules/Platform/{UnixPaths,Darwin}.cmake || die "sed failed"

	CMAKE_BINARY="${S}/Bootstrap.cmk/cmake"
	cmake_src_bootstrap
}

src_configure() {
	# Fix linking on Solaris
	[[ ${CHOST} == *-solaris* ]] && append-ldflags -lsocket -lnsl

	local mycmakeargs=(
		-DCMAKE_USE_SYSTEM_LIBRARIES=ON
		-DCMAKE_USE_SYSTEM_LIBRARY_JSONCPP=OFF
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}"/usr/lib/cmake-bootstrap
		-DCMAKE_DOC_DIR=/removeme
		-DCMAKE_MAN_DIR=/removeme
		-DCMAKE_DATA_DIR=/share/cmake
		-DSPHINX_MAN=OFF
		-DSPHINX_HTML=OFF
		-DBUILD_CursesDialog=OFF
		-DBUILD_QtDialog=OFF
		-DBUILD_TESTING=OFF
	)

	cmake-utils_src_configure
}

src_test() { :; }

src_install() {
	cmake-utils_src_install

	rm -r "${ED}"/usr/lib/cmake-bootstrap/removeme || die
	rm -r "${ED}"/usr/lib/cmake-bootstrap/share/cmake/{completions,editors} || die
}
