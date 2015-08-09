# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="View and upload map files, track and waypoint data to your Garmin GPS device"
HOMEPAGE="http://www.qlandkarte.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus dmtx exif gps +gpsbabel +gpx-extensions mikrokopter +rmap"

RDEPEND="
	>=sci-libs/gdal-1.8
	>=sci-libs/proj-4.7
	sys-libs/zlib
	dev-qt/qtgui:4
	dev-qt/qtscript:4
	dev-qt/qtsql:4[sqlite]
	dev-qt/qtwebkit:4
	dbus? ( dev-qt/qtdbus:4 )
	dmtx? ( media-libs/libdmtx )
	exif? ( media-libs/libexif )
	gps? ( >=sci-geosciences/gpsd-2.90 )
	gpsbabel? ( sci-geosciences/gpsbabel )
	dev-qt/qtopengl:4
	virtual/glu
"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use dbus DBUS)
		$(cmake-utils_use dmtx WITH_DMTX)
		$(cmake-utils_use exif WITH_EXIF)
		$(cmake-utils_use gps WITH_GPSD)
		$(cmake-utils_use gpx-extensions GPX_EXTENSIONS)
		$(cmake-utils_use mikrokopter MIKROKOPTER)
		$(cmake-utils_use rmap RMAP)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	sed \
		-e 's:\(Geography;\):\1Education;:g' \
		-i ./qlandkartegt.desktop || die
}

pkg_postinst() {
	elog "OSM and Opencyclemap internal definitions were dropped upstream"
	elog "Add it through File -> Load Online Map"
	elog "or add a tsm definition (http://wiki.openstreetmap.org/wiki/MapQuest#Tile_URLs)"
}
