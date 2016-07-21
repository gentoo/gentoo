# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="Pycadia. Home to vector gaming, python style"
HOMEPAGE="http://www.anti-particle.com/pycadia.shtml"
SRC_URI="http://www.anti-particle.com/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE=""

DEPEND=">=dev-python/pygame-1.5.5
	dev-python/pygtk:2"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	{
		echo "#!/bin/sh"
		echo "cd ${GAMES_DATADIR}/${PN}"
		echo "exec python2 ./pycadia.py \"\${@}\""
	} > "${T}/pycadia"
}

src_install() {
	dogamesbin "${T}/pycadia"

	insinto "${GAMES_DATADIR}/${PN}"
	doins -r {glade,pixmaps,sounds} *.py pycadia.conf

	exeinto "${GAMES_DATADIR}/${PN}"
	doexe pycadia.py spacewarpy.py vektoroids.py

	newicon pixmaps/pysteroids.png ${PN}.png
	make_desktop_entry ${PN} Pycadia

	dodoc doc/{TODO,CHANGELOG,README}
	prepgamesdirs
}
