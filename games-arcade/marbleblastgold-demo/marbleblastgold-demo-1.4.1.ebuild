# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit unpacker games

DESCRIPTION="race marbles through crazy stages"
HOMEPAGE="http://www.garagegames.com/pg/product/view.php?id=15"
SRC_URI="ftp://ggdev-1.homelan.com/marbleblastgold/MarbleBlastGoldDemo-${PV}.sh.bin"

LICENSE="MARBLEBLAST"
SLOT="0"
KEYWORDS="-* ~amd64 x86"
IUSE=""
RESTRICT="strip"

RDEPEND="sys-libs/glibc"

dir=${GAMES_PREFIX_OPT}/${PN}
QA_PREBUILT="${dir:1}/marbleblastgolddemo.bin
	${dir:1}/lib/*"

S=${WORKDIR}

src_install() {
	dodir "${dir}" "${GAMES_BINDIR}"

	tar -zxf MarbleBlast.tar.gz -C "${D}/${dir}" || die "extracting MarbleBlast.tar.gz"

	exeinto "${dir}"
	doexe bin/Linux/x86/marbleblastgolddemo
	dosym "${dir}"/marbleblastgolddemo "${GAMES_BINDIR}"/marbleblastgold-demo

	insinto "${dir}"
	doins MarbleBlast.xpm

	dodoc README.txt

	prepgamesdirs
}
