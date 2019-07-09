# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils xdg-utils gnome2-utils

DESCRIPTION="GPS mapping utility"
HOMEPAGE="https://bitbucket.org/maproom/qmapshack/wiki/Home"
SRC_URI="https://bitbucket.org/maproom/${PN}/downloads/${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="dev-qt/qtwebengine:5[widgets]
	dev-qt/qtdeclarative:5[widgets]
	dev-qt/qtprintsupport:5
	dev-qt/qtdbus:5
	dev-qt/qttest:5
	dev-qt/designer:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtsql:5
	dev-libs/quazip
	>=sci-geosciences/routino-3.1.1
	sci-libs/gdal
	sci-libs/proj
	sci-libs/alglib"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5"

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}
