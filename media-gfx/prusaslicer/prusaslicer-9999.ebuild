# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"
MY_PN="PrusaSlicer"
MY_PV="$(ver_rs 3 -)"

inherit cmake wxwidgets xdg

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/prusa3d/prusaslicer.git"
else
	SRC_URI="https://github.com/prusa3d/PrusaSlicer/archive/refs/tags/version_${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
	S="${WORKDIR}/${MY_PN}-version_${MY_PV}"
fi

DESCRIPTION="A mesh slicer to generate G-code for fused-filament-fabrication (3D printers)"
HOMEPAGE="https://www.prusa3d.com/prusaslicer/"

LICENSE="AGPL-3 Boost-1.0 GPL-2 LGPL-3 MIT"
SLOT="0"
IUSE="test"

RESTRICT="!test? ( test )"

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
	net-misc/curl[adns]
	media-libs/glew:0=
	media-libs/libjpeg-turbo:=
	media-libs/libpng:0=
	media-libs/qhull:=
	sci-libs/libigl
	sci-libs/nlopt
	sci-libs/opencascade:=
	sci-mathematics/cgal:=
	sys-apps/dbus
	sys-libs/zlib:=
	virtual/opengl
	x11-libs/gtk+:3
	>=x11-libs/wxGTK-3.2.2.1-r3:${WX_GTK_VER}[X,opengl,webkit]
	media-libs/nanosvg:=
"
DEPEND="${RDEPEND}
	media-libs/qhull[static-libs]
	test? ( =dev-cpp/catch-2* )
"

PATCHES=(
	"${FILESDIR}/${PN}-2.6.0-dont-force-link-to-wayland-and-x11.patch"
	"${FILESDIR}/${PN}-2.8.0-missing-includes.patch"
	"${FILESDIR}/${PN}-2.8.0-fixed-linking.patch"
)

src_prepare() {
	if has_version ">=sci-libs/opencascade-7.8.0"; then
		eapply "${FILESDIR}/prusaslicer-2.7.2-opencascade-7.8.0.patch"
	fi

	sed -i -e 's/PrusaSlicer-${SLIC3R_VERSION}+UNKNOWN/PrusaSlicer-${SLIC3R_VERSION}+Gentoo/g' version.inc || die

	sed -i -e 's/find_package(OpenCASCADE 7.6.2 REQUIRED)/find_package(OpenCASCADE REQUIRED)/g' \
		src/occt_wrapper/CMakeLists.txt || die
	cmake_src_prepare
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

src_test() {
	CMAKE_SKIP_TESTS=(
		"^libslic3r_tests$"
	)
	cmake_src_test
}
