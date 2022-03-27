# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# solvespace's libdxfrw is quite heavily modified and incompatible with
# the upstream libdxfrw.
DXFRW_COMMIT="0b7b7b709d9299565db603f878214656ef5e9ddf"
DXFRW_PV="0.6.3"
DXFRW_P="libdxfrw-${DXFRW_PV}-${DXFRW_COMMIT}"

inherit cmake toolchain-funcs xdg

DESCRIPTION="Parametric 2d/3d CAD"
HOMEPAGE="http://solvespace.com"
SRC_URI="https://github.com/solvespace/solvespace/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/solvespace/libdxfrw/archive/${DXFRW_COMMIT}.tar.gz -> ${DXFRW_P}.tar.gz"

# licenses
# + SolveSpace (GPL-3+)
# |- Bitstream Vera (BitstreamVera)
# + libdxfrw (GPL-2+)

IUSE="openmp"
KEYWORDS="~amd64"
LICENSE="BitstreamVera GPL-2+ GPL-3+"
SLOT="0"

RDEPEND="
	dev-cpp/atkmm:0
	dev-cpp/glibmm:2
	dev-cpp/gtkmm:3.0[X]
	dev-cpp/pangomm:1.4
	dev-libs/glib:2
	dev-libs/json-c:=
	dev-libs/libsigc++:2
	dev-libs/libspnav[X]
	dev-libs/mimalloc:=
	media-libs/fontconfig
	media-libs/freetype:2[X]
	media-libs/libpng:0=
	sys-libs/zlib
	virtual/opengl
	x11-libs/cairo[X]
	x11-libs/gtk+:3[X]
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-3.0-use-system-mimalloc.patch )

# This is shown to the user in the UI and --version.
MY_HASH="0e0b0252e23dd5bd4ae82ababcc54c44aee036d6"

pkg_pretend() {
	if use openmp; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
}

src_prepare() {
	rm -r extlib/libdxfrw || die
	mv "${WORKDIR}"/libdxfrw-${DXFRW_COMMIT} extlib/libdxfrw || die

	sed -i '/include(GetGitCommitHash)/d' CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_OPENMP=$(usex openmp)
		-DGIT_COMMIT_HASH=${MY_HASH}
	)

	cmake_src_configure
}
