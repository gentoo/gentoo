# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils gnome2-utils

DESCRIPTION="Lightweight and cross-platform clipboard history applet"
HOMEPAGE="https://github.com/pvanek/qlipper"
SRC_URI="https://github.com/pvanek/qlipper/archive/5.0.0.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# bundles x11-libs/libqxt but no qt5 system version is available yet
RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	x11-libs/libX11
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
"

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
