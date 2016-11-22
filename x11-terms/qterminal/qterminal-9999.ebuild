# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit cmake-utils git-r3 gnome2-utils

DESCRIPTION="Qt-based multitab terminal emulator"
HOMEPAGE="https://github.com/lxde/qterminal"
EGIT_REPO_URI="https://github.com/lxde/qterminal.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	x11-libs/libX11
	~x11-libs/qtermwidget-${PV}
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${PN}-no-liblxqt.patch" )

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
