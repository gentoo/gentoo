# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_KDEINSTALLDIRS=false
inherit ecm optfeature

DESCRIPTION="Simple but powerful Qt-based image viewer"
HOMEPAGE="https://photoqt.org/"
SRC_URI="https://photoqt.org/pkgs/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="devil exif freeimage graphicsmagick imagemagick mpv pdf raw"

COMMON_DEPEND="
	app-arch/libarchive:=
	app-arch/unrar
	dev-libs/pugixml
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5[jpeg]
	dev-qt/qtimageformats:5
	dev-qt/qtmultimedia:5[qml]
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsql:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	devil? ( media-libs/devil )
	exif? ( media-gfx/exiv2:= )
	freeimage? ( media-libs/freeimage )
	imagemagick? (
		!graphicsmagick? ( media-gfx/imagemagick:=[cxx] )
		graphicsmagick? ( media-gfx/graphicsmagick:=[cxx] )
	)
	mpv? ( media-video/mpv[libmpv] )
	pdf? ( app-text/poppler[qt5] )
	raw? ( media-libs/libraw:= )
"
DEPEND="${COMMON_DEPEND}
	dev-qt/qtconcurrent:5
"
RDEPEND="${COMMON_DEPEND}
	dev-qt/qtgraphicaleffects:5
	dev-qt/qtquickcontrols:5
	dev-qt/qtquickcontrols2:5
"
BDEPEND="dev-qt/linguist-tools:5"

src_configure() {
	local mycmakeargs=(
		-DCHROMECAST=OFF # TODO needs python
		-DDEVIL=$(usex devil)
		-DEXIV2=$(usex exif)
		-DFREEIMAGE=$(usex freeimage)
		-DGRAPHICSMAGICK=$(usex graphicsmagick $(usex imagemagick))
		-DIMAGEMAGICK=$(usex imagemagick $(usex !graphicsmagick))
		-DVIDEO_MPV=$(usex mpv)
		-DPOPPLER=$(usex pdf)
		-DRAW=$(usex raw)
	)
	ecm_src_configure
}

pkg_postinst() {
	optfeature "additional image formats like AVIF, EPS, HEIF/HEIC, PSD, etc." kde-frameworks/kimageformats
	ecm_pkg_postinst
}
