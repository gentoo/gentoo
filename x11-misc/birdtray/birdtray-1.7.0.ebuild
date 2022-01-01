# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg-utils

DESCRIPTION="A new mail system tray notification icon for Thunderbird"
HOMEPAGE="https://github.com/gyunaev/birdtray"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/gyunaev/birdtray.git"
else
	SRC_URI="https://github.com/gyunaev/${PN}/archive/RELEASE_${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-RELEASE_${PV}"
fi

LICENSE="GPL-3"
SLOT="0"

RDEPEND="dev-db/sqlite:=
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	x11-libs/libX11"

DEPEND="${RDEPEND}"

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
