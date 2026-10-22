# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# solvespace's libdxfrw is quite heavily modified and incompatible with
# the upstream libdxfrw.
DXFRW_COMMIT="8359399ff3eb96aec14fb160c9a5bc4796b60717"
DXFRW_PV="0.6.3"
DXFRW_P="libdxfrw-${DXFRW_PV}-${DXFRW_COMMIT}"

# dynamically linking with mimalloc causes segfaults when changing
# language. bug #852839
MIMALLOC_COMMIT="f81bf1b31af819a31195e08f9546dc80f8931587"
MIMALLOC_PV="2.2.2"
MIMALLOC_P="mimalloc-${MIMALLOC_PV}-${MIMALLOC_COMMIT}"

inherit cmake toolchain-funcs xdg

DESCRIPTION="Parametric 2d/3d CAD"
HOMEPAGE="https://solvespace.com"
SRC_URI="https://github.com/solvespace/solvespace/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/solvespace/libdxfrw/archive/${DXFRW_COMMIT}.tar.gz -> ${DXFRW_P}.tar.gz
	https://github.com/microsoft/mimalloc/archive/${MIMALLOC_COMMIT}.tar.gz -> ${MIMALLOC_P}.tar.gz"

# licenses
# + SolveSpace (GPL-3+)
# |- Bitstream Vera (BitstreamVera)
# + libdxfrw (GPL-2+)
# + mimalloc (MIT)

LICENSE="BitstreamVera GPL-2+ GPL-3+ MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="openmp"

RDEPEND="
	dev-cpp/eigen:=
	dev-cpp/glibmm:2
	dev-cpp/gtkmm:3.0[X]
	dev-cpp/pangomm:1.4
	dev-libs/glib:2
	dev-libs/json-c:=
	dev-libs/libsigc++:2
	dev-libs/libspnav[X]
	media-libs/fontconfig
	media-libs/freetype:2[X]
	media-libs/libpng:0=
	virtual/zlib:=
	virtual/opengl
	x11-libs/cairo[X]
	x11-libs/gtk+:3[X]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="virtual/pkgconfig"

# This is shown to the user in the UI and --version and should be
# updated during each version bump.
MY_HASH="30e1c3ac0beb77fe3e098315b1bb662840ddc99a"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	rm -r extlib/libdxfrw || die
	mv "${WORKDIR}"/libdxfrw-${DXFRW_COMMIT} extlib/libdxfrw || die

	rm -r extlib/mimalloc || die
	mv "${WORKDIR}"/mimalloc-${MIMALLOC_COMMIT} extlib/mimalloc || die

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
