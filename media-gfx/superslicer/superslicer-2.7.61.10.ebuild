# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"
MY_PN="SuperSlicer"
SLICER_PROFILES_COMMIT="c3fc5fd5948c74c51dd6d49d1521b6059eb82f7d"

inherit cmake wxwidgets xdg

DESCRIPTION="A mesh slicer to generate G-code for fused-filament-fabrication (3D printers)"
HOMEPAGE="https://github.com/supermerill/SuperSlicer/"
SRC_URI="
	https://github.com/supermerill/SuperSlicer/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/slic3r/slic3r-profiles/archive/${SLICER_PROFILES_COMMIT}.tar.gz -> ${P}-profiles.tar.gz
"

S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="AGPL-3 Boost-1.0 GPL-2 LGPL-3 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"
RESTRICT="test"

RDEPEND="
	dev-cpp/eigen:3
	dev-cpp/tbb:=
	dev-libs/boost:=[nls]
	dev-libs/cereal
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/gmp:=
	dev-libs/mpfr:=
	media-gfx/openvdb:=
	media-gfx/libbgcode
	media-libs/fontconfig
	net-misc/curl[adns]
	media-libs/glew:0=
	media-libs/libjpeg-turbo:=
	media-libs/libpng:0=
	media-libs/nanosvg
	sci-libs/libigl
	sci-libs/nlopt
	sci-libs/opencascade:=
	sci-mathematics/cgal:=
	sys-apps/dbus
	virtual/opengl
	x11-libs/gtk+:3
	x11-libs/wxGTK:${WX_GTK_VER}=[X,opengl]
"
DEPEND="${RDEPEND}
	media-libs/qhull[static-libs]
"

PATCHES=(
	"${FILESDIR}/${PN}-${PV}-fix-boost.patch"
	"${FILESDIR}/${PN}-${PV}-fix-libexpat.patch"
	"${FILESDIR}/${PN}-${PV}-fix-cutsurface.patch"
	"${FILESDIR}/${PN}-${PV}-fix-seam-placer.patch"
	"${FILESDIR}/${PN}-${PV}-fix-bonjour-deadline-timer.patch"
)

src_unpack() {
	default

	mv slic3r-profiles-*/* "${S}"/resources/profiles/ || die
}

src_configure() {
	CMAKE_BUILD_TYPE="Release"

	setup-wxwidgets

	local mycmakeargs=(
		-DOPENVDB_FIND_MODULE_PATH="/usr/$(get_libdir)/cmake/OpenVDB"

		-DSLIC3R_BUILD_TESTS=$(usex test)
		-DSLIC3R_FHS=ON
		-DSLIC3R_GTK=3
		-DSLIC3R_GUI=ON
		-DSLIC3R_PCH=OFF
		-DSLIC3R_STATIC=OFF
		-DSLIC3R_WX_STABLE=ON
		-Wno-dev
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	rm "${ED}/usr/lib/udev/rules.d/90-3dconnexion.rules" || die
}
