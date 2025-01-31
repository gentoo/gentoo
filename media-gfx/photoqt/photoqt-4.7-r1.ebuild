# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit cmake optfeature python-single-r1 toolchain-funcs xdg

DESCRIPTION="Simple but powerful Qt-based image viewer"
HOMEPAGE="https://photoqt.org/"
SRC_URI="https://photoqt.org/downloads/source/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="barcode chromecast devil exif freeimage geolocation graphicsmagick +imagemagick lcms mpv pdf raw vips"
REQUIRED_USE="chromecast? ( ${PYTHON_REQUIRED_USE} )"

COMMON_DEPEND="
	app-arch/libarchive:=
	dev-libs/pugixml
	dev-qt/qtbase:6[dbus,concurrent,gui,network,sql,widgets,xml]
	dev-qt/qtdeclarative:6[opengl]
	dev-qt/qtimageformats:6
	dev-qt/qtmultimedia:6[qml]
	dev-qt/qtsvg:6
	barcode? ( media-libs/zxing-cpp:= )
	chromecast? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep 'dev-python/pychromecast')
	)
	devil? ( media-libs/devil )
	exif? ( media-gfx/exiv2:=[bmff] )
	freeimage? ( media-libs/freeimage )
	imagemagick? (
		!graphicsmagick? ( media-gfx/imagemagick:=[cxx] )
		graphicsmagick? ( media-gfx/graphicsmagick:=[cxx] )
	)
	lcms? ( media-libs/lcms:2 )
	mpv? ( media-video/mpv:=[libmpv] )
	pdf? ( app-text/poppler[qt6] )
	raw? ( media-libs/libraw:= )
	vips? (
		dev-libs/glib:2
		media-libs/vips:=
	)
"
RDEPEND="${COMMON_DEPEND}
	geolocation? (
		dev-qt/qtlocation:6
		dev-qt/qtpositioning:6[qml]
	)
"
DEPEND="${COMMON_DEPEND}
	vips? ( x11-base/xorg-proto )
"
BDEPEND="
	dev-qt/qttools:6[linguist]
	>=kde-frameworks/extra-cmake-modules-6.5.0:*
	virtual/pkgconfig
	chromecast? ( ${PYTHON_DEPS} )
"

pkg_setup() {
	use chromecast && python-single-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DCHROMECAST=$(usex chromecast)
		-DDEVIL=$(usex devil)
		-DEXIV2=$(usex exif)
		-DEXIV2_ENABLE_BMFF=$(usex exif)
		-DFREEIMAGE=$(usex freeimage)
		-DGRAPHICSMAGICK=$(usex graphicsmagick $(usex imagemagick))
		-DIMAGEMAGICK=$(usex imagemagick $(usex !graphicsmagick))
		-DLCMS2=$(usex lcms)
		-DLOCATION=$(usex geolocation)
		-DVIDEO_MPV=$(usex mpv)
		-DPOPPLER=$(usex pdf)
		-DRAW=$(usex raw)
		-DRESVG=OFF # qt5 only
		-DLIBVIPS=$(usex vips)
		-DZXING=$(usex barcode)
	)

	if use imagemagick && use graphicsmagick; then
		mycmakeargs+=(
			-DMAGICK++_INCLUDE_DIR=$($(tc-getPKG_CONFIG) --variable=includedir GraphicsMagick++)
		)
	fi

	cmake_src_configure
}

pkg_postinst() {
	optfeature "additional image formats like AVIF, EPS, HEIF/HEIC, PSD, etc." "kde-frameworks/kimageformats:6"
	xdg_pkg_postinst
}
