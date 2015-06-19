# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/4stattack/4stattack-2.1.4.ebuild,v 1.11 2015/02/06 13:42:19 ago Exp $

EAPI=5
inherit eutils games

DESCRIPTION="Connect-4 game, single or network multiplayer"
HOMEPAGE="http://forcedattack.sourceforge.net/"
SRC_URI="mirror://sourceforge/forcedattack/4stAttack-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ppc x86"
IUSE=""

DEPEND=""
RDEPEND="dev-python/pygame"

S=${WORKDIR}/4stAttack-${PV}

src_prepare() {
	# move the doc files aside so it's easier to install the game files
	mv README.txt credits.txt changelog.txt ..
	rm -f GPL version~

	# This patch makes the game save settings in $HOME
	epatch "${FILESDIR}"/${P}-gentoo.diff
}

src_install() {
	games_make_wrapper ${PN} "python ${PN}.py" "${GAMES_DATADIR}"/${PN}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r *
	newicon kde/icons/48x48/forcedattack2.png ${PN}.png
	make_desktop_entry ${PN} "4st Attack 2"
	dodoc ../{README.txt,credits.txt,changelog.txt}
	prepgamesdirs
}
