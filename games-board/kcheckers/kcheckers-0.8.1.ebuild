# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/kcheckers/kcheckers-0.8.1.ebuild,v 1.12 2015/02/06 13:43:09 ago Exp $

EAPI=5
inherit eutils qt4-r2 games

DESCRIPTION="Qt version of the classic boardgame checkers"
HOMEPAGE="http://qcheckers.sourceforge.net/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc x86"
IUSE=""

DEPEND="dev-qt/qtgui:4"

src_prepare() {
	sed -i \
		-e "s:/usr/local:${GAMES_DATADIR}:" \
		common.h || die

	sed -i \
		-e "s:PREFIX\"/share:\"${GAMES_DATADIR}:" \
		main.cc toplevel.cc || die
}

src_configure() {
	qt4-r2_src_configure
}

src_install() {
	dogamesbin kcheckers

	insinto "${GAMES_DATADIR}"/${PN}
	doins -r i18n/* themes

	newicon icons/biglogo.png ${PN}.png
	make_desktop_entry ${PN} KCheckers

	dodoc AUTHORS ChangeLog FAQ README TODO
	prepgamesdirs
}
