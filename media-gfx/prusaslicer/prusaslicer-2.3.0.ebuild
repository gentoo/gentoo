# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0-gtk3"

inherit xdg cmake desktop wxwidgets

MY_PN="PrusaSlicer"

DESCRIPTION="A mesh slicer to generate G-code for fused-filament-fabrication (3D printers)"
HOMEPAGE="https://www.prusa3d.com/prusaslicer/"
SRC_URI="https://github.com/prusa3d/${MY_PN}/archive/version_${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3 Boost-1.0 GPL-2 LGPL-3 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gui test"

# tests fail to link with USE=-gui, bug #760096
REQUIRED_USE="test? ( gui )"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-cpp/eigen:3
	dev-cpp/tbb
	>=dev-libs/boost-1.73.0:=[nls,threads]
	dev-libs/cereal
	dev-libs/expat
	dev-libs/gmp:=
	>=dev-libs/miniz-2.1.0-r2
	dev-libs/mpfr:=
	>=media-gfx/openvdb-5.0.0
	media-libs/ilmbase:=
	media-libs/libpng:0=
	media-libs/qhull:=
	sci-libs/libigl
	sci-libs/nlopt
	>=sci-mathematics/cgal-5.0:=
	sys-apps/dbus
	sys-libs/zlib:=
	gui? (
		dev-libs/glib:2
		media-libs/glew:0=
		net-misc/curl
		virtual/glu
		virtual/opengl
		x11-libs/gtk+:3
		x11-libs/wxGTK:${WX_GTK_VER}[X,opengl]
	)
"
DEPEND="${RDEPEND}
	media-libs/qhull[static-libs]
"

S="${WORKDIR}/${MY_PN}-version_${PV}"

PATCHES=(
	"${FILESDIR}/${P}-miniz-zip-header.patch"
)

src_configure() {
	use gui && setup-wxwidgets

	local mycmakeargs=(
		-DSLIC3R_BUILD_TESTS=$(usex test)
		-DSLIC3R_FHS=ON
		-DSLIC3R_GTK=3
		-DSLIC3R_GUI=$(usex gui)
		-DSLIC3R_PCH=OFF
		-DSLIC3R_WX_STABLE=ON
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use gui; then
		newicon -s 128 resources/icons/PrusaSlicer_128px.png PrusaSlicer.png
		newicon -s 128 resources/icons/PrusaSlicer-gcodeviewer_128px.png PrusaSlicer-gcodeviewer.png
		domenu src/platform/unix/Prusa{Slicer,Gcodeviewer}.desktop
	fi
}
