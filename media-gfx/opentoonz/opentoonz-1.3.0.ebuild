# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils gnome2-utils xdg-utils

DESCRIPTION="An open-source full-featured 2D animation creation software"
HOMEPAGE="https://github.com/opentoonz/opentoonz"
SRC_URI="https://github.com/opentoonz/opentoonz/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD libtiff"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	app-arch/lz4:=
	>=dev-libs/boost-1.55.0:=
	dev-libs/lzo:2
	>=dev-qt/qtcore-5.9:5
	>=dev-qt/qtgui-5.9:5
	>=dev-qt/qtmultimedia-5.9:5[widgets]
	>=dev-qt/qtnetwork-5.9:5
	>=dev-qt/qtopengl-5.9:5
	>=dev-qt/qtprintsupport-5.9:5
	>=dev-qt/qtscript-5.9:5
	>=dev-qt/qtsvg-5.9:5
	>=dev-qt/qtwidgets-5.9:5
	>=dev-qt/qtxml-5.9:5
	media-libs/freeglut
	media-libs/freetype:2
	media-libs/glew:=
	media-libs/libjpeg-turbo
	>=media-libs/libmypaint-1.3.0:=
	media-libs/libpng:=
	media-libs/libsdl2
	sci-libs/cblas-reference
	>=sci-libs/superlu-4.1:=
	sys-libs/zlib:=
	virtual/libusb:=
	virtual/opengl
"
DEPEND="
	${RDEPEND}
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

CMAKE_USE_DIR="${S}"/toonz/sources

src_configure() {
	local mycmakeargs=(
		-DTIFF_LIBRARY="${S}/thirdparty/tiff-4.0.3/libtiff/.libs/libtiff.a"
		-DSUPERLU_INCLUDE_DIR="${EPREFIX%/}/usr/include/superlu"
		-DLZO_INCLUDE_DIR="${EPREFIX%/}/usr/include/lzo"
		-DCMAKE_SKIP_RPATH=ON
	)

	# The upstream uses their own modified libtiff
	# See: https://github.com/opentoonz/opentoonz/blob/master/doc/how_to_build_linux.md#building-libtiff
	cd thirdparty/tiff-4.0.3 || die
	econf \
		--with-pic \
		--disable-jbig \
		--enable-static \
		--disable-shared

	cmake-utils_src_configure
}

src_compile() {
	cd "${S}"/thirdparty/tiff-4.0.3 || die
	emake

	cmake-utils_src_compile
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}
