# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/cgoban2/cgoban2-2.6.12.ebuild,v 1.6 2015/02/06 13:43:34 ago Exp $

EAPI=5
inherit games

DESCRIPTION="A Java client for the Kiseido Go Server, and a SGF editor"
HOMEPAGE="http://www.gokgs.com/"
SRC_URI="mirror://gentoo/cgoban-unix-${PV}.tar.bz2"

LICENSE="freedist"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND=">=virtual/jre-1.3"

S=${WORKDIR}/cgoban

src_install() {
	dodir "${GAMES_BINDIR}"
	sed -e "s:INSTALL_DIR:${GAMES_DATADIR}/${PN}:" \
		"${FILESDIR}/${PN}" > "${D}${GAMES_BINDIR}/${PN}" || die
	insinto "${GAMES_DATADIR}/${PN}"
	doins cgoban.jar
	prepgamesdirs
}
