# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils fdo-mime

DESCRIPTION="Qt-based image viewer"
HOMEPAGE="http://www.nomacs.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}-source.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux"
IUSE="opencv qt5 raw tiff webp zip"

REQUIRED_USE="
	raw? ( opencv )
	tiff? ( opencv )
"

RDEPEND="
	>=media-gfx/exiv2-0.25:=
	qt5? (
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtprintsupport:5
		dev-qt/qtwidgets:5
		opencv? ( media-libs/opencv:=[qt5] )
		zip? ( dev-libs/quazip[qt5] )
	)
	!qt5? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		opencv? ( >=media-libs/opencv-2.4:=[qt4] )
		zip? ( dev-libs/quazip[qt4] )
	)
	raw? ( >=media-libs/libraw-0.14:= )
	tiff? ( media-libs/tiff:0 )
	webp? ( >=media-libs/libwebp-0.3.1:= )
"
DEPEND="${RDEPEND}
	qt5? ( dev-qt/linguist-tools:5 )
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}/${PN}-3.0.0-opencv3.patch" )

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable opencv)
		$(cmake-utils_use_enable qt5)
		$(cmake-utils_use_enable raw)
		$(cmake-utils_use_enable tiff)
		$(cmake-utils_use_enable webp)
		$(cmake-utils_use_enable zip QUAZIP)
		-DUSE_SYSTEM_WEBP=ON
		-DUSE_SYSTEM_QUAZIP=ON
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
