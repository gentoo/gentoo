# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit games

DESCRIPTION="A Java client for the Kiseido Go Server, and a SGF editor"
HOMEPAGE="http://www.gokgs.com/"
SRC_URI="mirror://gentoo/cgoban-unix-${PV}.tar.bz2"

LICENSE="freedist"
SLOT="0"
KEYWORDS="amd64 x86"
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
