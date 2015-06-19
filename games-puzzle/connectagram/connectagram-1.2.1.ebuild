# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/connectagram/connectagram-1.2.1.ebuild,v 1.1 2015/02/08 07:32:12 mr_bones_ Exp $

EAPI=5
inherit eutils gnome2-utils qmake-utils games

DESCRIPTION="A word unscrambling game"
HOMEPAGE="http://gottcode.org/connectagram/"
SRC_URI="http://gottcode.org/${PN}/${P}-src.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-qt/qtcore-5.2:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	>=dev-qt/qtgui-5.2:5"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch

	sed -i \
		-e "s#@GAMES_BINDIR@#${GAMES_BINDIR}#" \
		-e "s#@GAMES_DATADIR@#${GAMES_DATADIR}#" \
		${PN}.pro src/{locale_dialog,new_game_dialog,wordlist}.cpp || die
}

src_configure() {
	eqmake5 connectagram.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	dodoc CREDITS ChangeLog NEWS README
	prepgamesdirs
}

pkg_preinst() {
	gnome2_icon_savelist
	games_pkg_preinst
}

pkg_postinst() {
	gnome2_icon_cache_update
	games_pkg_postinst
}

pkg_postrm() {
	gnome2_icon_cache_update
}
