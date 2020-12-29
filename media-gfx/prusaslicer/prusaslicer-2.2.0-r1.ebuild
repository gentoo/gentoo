# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0-gtk3"

inherit cmake desktop wxwidgets xdg-utils

MY_PN="PrusaSlicer"

DESCRIPTION="A mesh slicer to generate G-code for fused-filament-fabrication (3D printers)"
HOMEPAGE="https://www.prusa3d.com/prusaslicer/"
SRC_URI="https://github.com/prusa3d/${MY_PN}/archive/version_${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3 CC-BY-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="gui test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-cpp/eigen:3
	dev-cpp/tbb
	>=dev-libs/boost-1.73.0:=[threads]
	dev-libs/cereal
	dev-libs/expat
	dev-libs/miniz
	media-libs/glew:0=
	media-libs/qhull
	>=media-gfx/openvdb-5.0.0
	net-misc/curl
	>=sci-mathematics/cgal-5.0
	sci-libs/libigl
	sci-libs/nlopt
	sys-libs/zlib
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	"
DEPEND="${RDEPEND}"

S="${WORKDIR}/PrusaSlicer-version_${PV}"
PATCHES=(
	"${FILESDIR}/${P}-atomic.patch"
	"${FILESDIR}/${P}-boost-1.73.patch"
)

src_prepare() {
	setup-wxwidgets
	cmake_src_prepare
}

src_configure() {
	CMAKE_BUILD_TYPE=Release

	local mycmakeargs=(
		-DSLIC3R_BUILD_TESTS=$(usex test)
		-DSLIC3R_FHS=1
		-DSLIC3R_GUI=$(usex gui)
		-DSLIC3R_PCH=0
	  -SLIC3R_STATIC=0
		-DSLIC3R_WX_STABLE=1
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	doicon resources/icons/PrusaSlicer.png || die
	domenu "${FILESDIR}/PrusaGcodeviewer.desktop" || die
	domenu "${FILESDIR}/PrusaSlicer.desktop" || die
}

pkg_postinst() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
