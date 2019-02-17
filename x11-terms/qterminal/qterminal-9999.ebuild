# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils git-r3 xdg-utils

DESCRIPTION="Qt-based multitab terminal emulator"
HOMEPAGE="https://github.com/lxde/qterminal"
EGIT_REPO_URI="https://github.com/lxde/qterminal.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE=""

BDEPEND="dev-util/lxqt-build-tools"
DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	x11-libs/libX11
	~x11-libs/qtermwidget-${PV}
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-nofetch.patch" )

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
