# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="Ancient Domains Of Mystery rogue-like game"
HOMEPAGE="http://www.adom.de/"
SRC_URI="http://www.adom.de/adom/download/linux/${P//.}-elf.tar.gz"

LICENSE="adom"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="strip" #bug #137340
QA_FLAGS_IGNORED="${GAMES_PREFIX_OPT:1}/bin/adom"

RDEPEND="|| (
	>=sys-libs/ncurses-5.9-r3:0/5[abi_x86_32(-)]
	>=sys-libs/ncurses-5.9-r3:5/5[abi_x86_32(-)] )"

S=${WORKDIR}/${PN}

src_install() {
	exeinto "${GAMES_PREFIX_OPT}/bin"
	doexe adom

	keepdir "${GAMES_STATEDIR}/${PN}"
	echo "${GAMES_STATEDIR}/${PN}" > adom_ds.cfg
	insinto /etc
	doins adom_ds.cfg

	edos2unix adomfaq.txt
	dodoc adomfaq.txt manual.doc readme.1st

	prepgamesdirs
	fperms g+w "${GAMES_STATEDIR}/${PN}"
}
