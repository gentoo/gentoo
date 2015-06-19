# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-mud/trebuchet/trebuchet-1.075.ebuild,v 1.5 2015/03/25 15:34:21 jlec Exp $

EAPI=5

inherit games

DESCRIPTION="A crossplatform TCL/TK based MUD client"
HOMEPAGE="http://belfry.com/fuzzball/trebuchet/"
SRC_URI="mirror://sourceforge/trebuchet/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""
RESTRICT="test"

RDEPEND="
	>=dev-lang/tk-8.3.3:0=
	dev-lang/tcl:0="

src_prepare() {
	sed -i \
		-e "/Nothing/d" \
		-e "/LN/ s:../libexec:${GAMES_DATADIR}:" \
		Makefile || die
}

src_install() {
	emake prefix="${D}/${GAMES_PREFIX}" \
		ROOT="${D}/${GAMES_DATADIR}/${PN}" install

	insinto "${GAMES_DATADIR}"/${PN}
	doins COPYING
	dodoc changes.txt readme.txt trebtodo.txt
	prepgamesdirs
}
