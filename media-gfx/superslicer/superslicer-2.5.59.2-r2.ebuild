# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.0-gtk3"
MY_PN="SuperSlicer"
SLICER_PROFILES_COMMIT="f6b1b123062a77101fe350f6d2a2a57be9adc684"

inherit cmake wxwidgets xdg flag-o-matic

DESCRIPTION="A mesh slicer to generate G-code for fused-filament-fabrication (3D printers)"
HOMEPAGE="https://github.com/supermerill/SuperSlicer/"
SRC_URI="
	https://github.com/supermerill/SuperSlicer/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/slic3r/slic3r-profiles/archive/${SLICER_PROFILES_COMMIT}.tar.gz -> ${P}-profiles.tar.gz
"

LICENSE="AGPL-3 Boost-1.0 GPL-2 LGPL-3 MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"

RESTRICT="test"

# No dep on sci-libs/libigl, in-tree version cannot build
# static library currently. Using bundled one.
RDEPEND="
	dev-cpp/eigen:3
	dev-cpp/tbb:=
	dev-libs/boost:=[nls]
	dev-libs/cereal
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/gmp:=
	dev-libs/mpfr:=
	dev-libs/imath:=
	>=media-gfx/openvdb-8.2:=
	net-misc/curl[adns]
	media-libs/glew:0=
	media-libs/libpng:0=
	media-libs/qhull:=
	sci-libs/nlopt
	sci-libs/opencascade:=
	>=sci-mathematics/cgal-5.0:=
	sys-apps/dbus
	sys-libs/zlib:=
	virtual/glu
	virtual/opengl
	x11-libs/gtk+:3
	x11-libs/wxGTK:${WX_GTK_VER}[X,opengl]
"
DEPEND="${RDEPEND}
	media-libs/qhull[static-libs]
"

PATCHES=(
	"${FILESDIR}/${P}-boost.patch"
	"${FILESDIR}/${P}-cereal.patch"
	"${FILESDIR}/${P}-dont-install-angelscript.patch"
	"${FILESDIR}/${P}-gcodeviewer-symlink-fix.patch"
	"${FILESDIR}/${P}-missing-includes-fix.patch"
	"${FILESDIR}/${P}-openexr3.patch"
	"${FILESDIR}/${P}-wxgtk3-wayland-fix.patch"
	"${FILESDIR}/${P}-relax-OpenCASCADE-dep.patch"
	"${FILESDIR}/${P}-link-occtwrapper-statically.patch"
	"${FILESDIR}/${P}-fix-dereferencing-in-std-unique_ptr-to-nullptr.patch"
	"${FILESDIR}/${P}-fix-spiral_vase-null-pointer.patch"
)

S="${WORKDIR}/${MY_PN}-${PV}"

src_unpack() {
	default

	mv slic3r-profiles-*/* "${S}"/resources/profiles/ || die
}

src_configure() {
	CMAKE_BUILD_TYPE="Release"

	append-flags -fno-strict-aliasing

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
