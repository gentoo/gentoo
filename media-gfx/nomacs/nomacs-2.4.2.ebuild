# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils fdo-mime

DESCRIPTION="Qt4-based image viewer"
HOMEPAGE="http://www.nomacs.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}-source.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~amd64-linux"
IUSE="opencv raw tiff webp zip"

REQUIRED_USE="raw? ( opencv ) tiff? ( opencv )"

RDEPEND="
	>=media-gfx/exiv2-0.20[zlib]
	>=dev-qt/qtcore-4.7.0:4
	>=dev-qt/qtgui-4.7.0:4
	opencv? ( >=media-libs/opencv-2.4.0[qt4] )
	raw? ( >=media-libs/libraw-0.14 )
	tiff? ( media-libs/tiff:0= )
	webp? ( >=media-libs/libwebp-0.3.1:= )
	zip? ( dev-libs/quazip )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${P}-include.patch"
	"${FILESDIR}/${PN}-3.0.0-opencv3.patch"
)

src_configure() {
	local mycmakeargs=(
		-DUSE_SYSTEM_WEBP=true
		-DUSE_SYSTEM_QUAZIP=true
		$(cmake-utils_use_enable opencv)
		$(cmake-utils_use_enable raw)
		$(cmake-utils_use_enable tiff)
		$(cmake-utils_use_enable webp)
		$(cmake-utils_use_enable zip QUAZIP)
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
