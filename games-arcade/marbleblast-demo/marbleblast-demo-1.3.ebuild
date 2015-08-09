# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=5
inherit unpacker games

DESCRIPTION="race marbles through crazy stages"
HOMEPAGE="http://www.garagegames.com/pg/product/view.php?id=3"
SRC_URI="ftp://ggdev-1.homelan.com/marbleblast/MarbleBlastDemo-${PV}.sh.bin"

LICENSE="MARBLEBLAST"
SLOT="0"
KEYWORDS="-* ~amd64 x86"
IUSE=""
RESTRICT="strip"

S=${WORKDIR}

dir=${GAMES_PREFIX_OPT}/${PN}
QA_PREBUILT="${dir:1}/marbleblastdemo.bin
	${dir:1}/lib/lib*"

src_install() {
	dodir "${dir}" "${GAMES_BINDIR}"

	tar -zxf MarbleBlast.tar.gz -C "${D}/${dir}" || die "extracting MarbleBlast.tar.gz"

	exeinto "${dir}"
	doexe bin/Linux/x86/marbleblastdemo
	dosym "${dir}"/marbleblastdemo "${GAMES_BINDIR}"/marbleblast-demo

	dodoc README_DEMO.txt

	prepgamesdirs
}
