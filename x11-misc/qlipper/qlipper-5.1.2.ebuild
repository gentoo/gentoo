# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg-utils

DESCRIPTION="Lightweight and cross-platform clipboard history applet"
HOMEPAGE="https://github.com/pvanek/qlipper"
SRC_URI="https://github.com/pvanek/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

# TODO: still accurate? bundles x11-libs/libqxt but no qt5 system version is available yet
RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	x11-libs/libX11
"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/linguist-tools:5"

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
