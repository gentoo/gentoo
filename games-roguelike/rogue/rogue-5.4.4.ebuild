# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit games

MY_P=${PN}${PV}
DESCRIPTION="The original graphical adventure game that spawned an entire genre"
HOMEPAGE="http://rogue.rogueforge.net/"
SRC_URI="http://rogue.rogueforge.net/files/rogue5.4/${MY_P}-src.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="sys-libs/ncurses[-tinfo]"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_configure() {
	egamesconf \
		--enable-scorefile="${GAMES_STATEDIR}/${PN}/${PN}.scr" \
		--docdir=/usr/share/doc/${PF}
}

src_install() {
	default
	prepgamesdirs
}
