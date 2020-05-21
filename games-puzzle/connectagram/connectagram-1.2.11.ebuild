# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils xdg-utils

DESCRIPTION="A word unscrambling game"
HOMEPAGE="https://gottcode.org/connectagram/"
SRC_URI="https://gottcode.org/${PN}/${P}-src.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

BDEPEND="
	dev-qt/linguist-tools:5
"
RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-1.2.8-gentoo.patch )

src_prepare() {
	default
	sed -i \
		-e "s#@GAMES_BINDIR@#/usr/bin#" \
		-e "s#@GAMES_DATADIR@#/usr/share#" \
		${PN}.pro src/{locale_dialog,new_game_dialog,wordlist}.cpp || die
}

src_configure() {
	eqmake5 connectagram.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
