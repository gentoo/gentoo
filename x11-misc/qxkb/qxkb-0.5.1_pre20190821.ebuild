# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT=ee9a1eee9dc810b33b931601203051d841bc3e7a
inherit cmake

DESCRIPTION="Qt-based keyboard layout switcher"
HOMEPAGE="https://github.com/disels/qxkb"
SRC_URI="https://github.com/disels/qxkb/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/${PN}-${COMMIT}"

PATCHES=( "${FILESDIR}/${P}-desktop.patch" )

BDEPEND="
	dev-qt/linguist-tools:5
"
DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	x11-libs/libX11
	x11-libs/libxkbfile
"
RDEPEND="${DEPEND}
	x11-apps/setxkbmap
"
