# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="Create as many words as you can before the time runs out"
HOMEPAGE="http://www.coralquest.com/anagramarama/"
SRC_URI="http://www.omega.clara.net/anagramarama/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=">=media-libs/libsdl-1.2
	>=media-libs/sdl-mixer-1.2
	>=media-libs/sdl-image-1.2"
RDEPEND="${DEPEND}
	sys-apps/miscfiles"

S=${WORKDIR}/${PN}

src_prepare() {
	sed -i \
		-e "s:wordlist.txt:${GAMES_DATADIR}\/${PN}\/wordlist.txt:" \
		-e "s:\"audio\/:\"${GAMES_DATADIR}\/${PN}\/audio\/:" \
		-e "s:\"images\/:\"${GAMES_DATADIR}\/${PN}\/images\/:" \
		src/{ag.c,dlb.c} \
		|| die "sed failed"
	ecvs_clean
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_install() {
	newgamesbin ag ${PN}
	insinto "${GAMES_DATADIR}/${PN}"
	doins wordlist.txt
	doins -r images/ audio/
	dodoc readme
	prepgamesdirs
}
