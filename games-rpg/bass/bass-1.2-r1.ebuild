# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=5
inherit eutils games

DESCRIPTION="Beneath a Steel Sky: a science fiction thriller set in a bleak vision of the future"
#HOMEPAGE="http://www.revgames.com/_display.php?id=16"
HOMEPAGE="http://en.wikipedia.org/wiki/Beneath_a_Steel_Sky"
SRC_URI="mirror://sourceforge/scummvm/bass-cd-${PV}.zip
	mirror://gentoo/${PN}.png"

LICENSE="bass"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE=""

RDEPEND=">=games-engines/scummvm-0.5.0"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/bass-cd-${PV}

src_install() {
	games_make_wrapper bass "scummvm -f -p \"${GAMES_DATADIR}/${PN}\" -q\$(scummvmGetLang.sh) sky" .
	dogamesbin "${FILESDIR}"/scummvmGetLang.sh
	insinto "${GAMES_DATADIR}"/${PN}
	doins sky.*
	dodoc readme.txt
	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} "Beneath a Steel Sky"
	prepgamesdirs
}
