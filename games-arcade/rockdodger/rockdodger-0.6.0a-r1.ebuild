# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/rockdodger/rockdodger-0.6.0a-r1.ebuild,v 1.12 2015/01/05 17:25:49 tupone Exp $

EAPI=5
inherit eutils games

DESCRIPTION="Dodge the rocks for as long as possible until you die"
HOMEPAGE="http://spacerocks.sourceforge.net/"
SRC_URI="mirror://sourceforge/spacerocks/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE=""

DEPEND="media-libs/libsdl[sound,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer"
RDEPEND="${DEPEND}"

src_prepare() {
	# Modify highscores & data directory and add our CFLAGS to the Makefile
	sed -i \
		-e "s:\./data:${GAMES_DATADIR}/${PN}:" \
		-e "s:/usr/share/rockdodger/\.highscore:${GAMES_STATEDIR}/rockdodger.scores:" \
		-e 's:umask(0111):umask(0117):' main.c \
		|| die " sed main.c failed"
	sed -i \
		-e "s:-g:${CFLAGS}:" \
		-e 's:cc:$(CC):' \
		-e '/-o/s:\$+:$(LDFLAGS) $+:' \
		Makefile \
		|| die "sed Makefile failed"

	# The 512 chunksize makes the music skip
	sed -i \
		-e "s:512:1024:" sound.c \
			|| die "sed sound.c failed"
	epatch \
		"${FILESDIR}"/${PV}-sec.patch \
		"${FILESDIR}"/${P}-gcc41.patch \
		"${FILESDIR}"/${P}-underlink.patch
}

src_install() {
	dogamesbin ${PN}
	insinto "${GAMES_DATADIR}"/${PN}
	doins data/*

	newicon spacerocks.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Rock Dodger" ${PN}

	dodir "${GAMES_STATEDIR}"
	touch "${D}/${GAMES_STATEDIR}"/${PN}.scores
	fperms 660 "${GAMES_STATEDIR}"/${PN}.scores
	prepgamesdirs
}
