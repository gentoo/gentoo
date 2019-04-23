# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils gnome2-utils xdg-utils

DESCRIPTION="Qt application for getting screenshots"
HOMEPAGE="https://lxqt.org/"
SRC_URI="https://downloads.lxqt.org/downloads/${PN}/${PV}/${P}.tar.xz"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE=""

DEPEND="
	>=dev-libs/libqtxdg-3.0.0
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtnetwork:5
	kde-frameworks/kwindowsystem:5[X]
	x11-libs/libxcb
	x11-libs/libX11
"
RDEPEND="${DEPEND}"

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}
