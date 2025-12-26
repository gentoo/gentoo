# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
inherit cmake optfeature python-single-r1 xdg

DESCRIPTION="Simple but powerful Qt-based image viewer"
HOMEPAGE="https://photoqt.org/"
SRC_URI="
	https://gitlab.com/lspies/photoqt/-/archive/v${PV}/${PN}-v${PV}.tar.bz2
	extensions? ( https://gitlab.com/lspies/photoqt-extensions/-/archive/v${PV}/${PN}-extensions-v${PV}.tar.bz2 )
"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="barcode chromecast devil exif extensions freeimage geolocation graphicsmagick +imagemagick lcms mpv pdf raw test vips wayland"
REQUIRED_USE="chromecast? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	app-arch/libarchive:=
	dev-libs/pugixml
	dev-qt/qtbase:6[concurrent,dbus,gui,icu,network,opengl,sql,sqlite,widgets,xml]
	dev-qt/qtdeclarative:6[opengl]
	dev-qt/qtimageformats:6
	dev-qt/qtmultimedia:6[qml]
	dev-qt/qtsvg:6
	barcode? ( media-libs/zxing-cpp:= )
	chromecast? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep 'dev-python/pychromecast[${PYTHON_USEDEP}]')
	)
	devil? ( media-libs/devil )
	exif? ( media-gfx/exiv2:=[bmff] )
	extensions? (
		app-crypt/qca:2
		dev-cpp/yaml-cpp:=
	)
	freeimage? ( media-libs/freeimage )
	imagemagick? (
		!graphicsmagick? ( media-gfx/imagemagick:=[cxx,hdri] )
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
	wayland? ( dev-libs/wayland )
"
RDEPEND="
	${COMMON_DEPEND}
	dev-qt/qtcharts:6[qml]
	geolocation? (
		dev-qt/qtlocation:6
		dev-qt/qtpositioning:6[qml]
	)
"
DEPEND="
	${COMMON_DEPEND}
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

src_unpack() {
	default
	if use extensions; then
		rmdir "${S}"/extensions || die
		ln -sfT ../${PN}-extensions-v${PV} "${S}"/extensions || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DWITH_ZXING=$(usex barcode)
		-DWITH_CHROMECAST=$(usex chromecast)
		-DWITH_DEVIL=$(usex devil)
		-DWITH_EXIV2=$(usex exif)
		-DWITH_EXIV2_ENABLE_BMFF=$(usex exif)
		-DWITH_EXTENSIONS_SUPPORT=$(usex extensions)
		-DWITH_FREEIMAGE=$(usex freeimage)
		-DWITH_LOCATION=$(usex geolocation)
		-DWITH_GRAPHICSMAGICK=$(usex graphicsmagick $(usex imagemagick))
		-DWITH_IMAGEMAGICK=$(usex imagemagick $(usex !graphicsmagick))
		-DWITH_LCMS2=$(usex lcms)
		-DWITH_VIDEO_MPV=$(usex mpv)
		-DWITH_POPPLER=$(usex pdf)
		-DWITH_LIBRAW=$(usex raw)
		-DWITH_LIBVIPS=$(usex vips)
		-DWITH_WAYLANDSPECIFIC=$(usex wayland)
		-DWITH_ADAPTSOURCE=ON # adapt the sources according to the Qt version
		-DWITH_LIBSAI=OFF # Wunkolo/libsai, no release, experimental
		-DWITH_QTPDF=OFF # use poppler instead
		-DWITH_RESVG=OFF # qt5 only
		-DWITH_TESTING=$(usex test)
	)

	cmake_src_configure
}

src_test() {
	local -x QT_QPA_PLATFORM=offscreen
	# QCollator::setNumericMode is not supported w/ POSIX/C locale or w/o icu
	# Set LC_COLLATE=en_US.utf8 if available.
	# Required for PQTScriptsFilesPaths::getFoldersIn()
	unset LC_COLLATE
	locale -a | grep -iq "en_US.utf8" || die "locale en_US.utf8 not available, testsuite not launched"
	LC_COLLATE="en_US.utf8" cmake_src_test -j1
}

pkg_postinst() {
	optfeature "additional image formats like AVIF, EPS, HEIF/HEIC, PSD, etc." "kde-frameworks/kimageformats:6"
	xdg_pkg_postinst
}
