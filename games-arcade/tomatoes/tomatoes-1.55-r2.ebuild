# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DATA_PV=1.5
DESCRIPTION="How many tomatoes can you smash in ten short minutes?"
HOMEPAGE="http://tomatoes.sourceforge.net/about.html"
SRC_URI="mirror://sourceforge/tomatoes/tomatoes-linux-src-${PV}.tar.bz2
	mirror://sourceforge/tomatoes/tomatoes-linux-${DATA_PV}.tar.bz2"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 ia64 ppc ~ppc64 x86"
IUSE=""

DEPEND="virtual/opengl
	virtual/glu
	media-libs/libsdl[sound,video]
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-mixer[mod]"
RDEPEND="${DEPEND}"

src_prepare() {
	mv ../tomatoes-1.5/* . || die "mv failed"
	mv icon.png ${PN}.png

	epatch \
		"${FILESDIR}"/${P}-c_str.patch \
		"${FILESDIR}"/${P}-underlink.patch \
		"${FILESDIR}"/${P}-gcc43.patch

	sed -i \
		-e "/^MPKDIR = /s:./:${GAMES_DATADIR}/${PN}/:" \
		-e "/^MUSICDIR = /s:./music/:${GAMES_DATADIR}/${PN}/music/:" \
		-e "/^HISCOREDIR = /s:./:${GAMES_STATEDIR}/${PN}/:" \
		-e "/^CONFIGDIR = /s:./:${GAMES_SYSCONFDIR}/${PN}/:" \
		-e "/^OVERRIDEDIR = /s:./data/:${GAMES_DATADIR}/${PN}/data/:" \
		makefile \
		|| die "sed failed"
}

src_install() {
	dogamesbin tomatoes
	dodoc README README-src

	insinto "${GAMES_DATADIR}"/${PN}
	doins -r tomatoes.mpk music

	doicon ${PN}.png
	make_desktop_entry tomatoes "I Have No Tomatoes"

	dodir "${GAMES_STATEDIR}"/${PN}
	touch "${D}${GAMES_STATEDIR}"/${PN}/hiscore.lst || die "touch failed"
	fperms 660 "${GAMES_STATEDIR}"/${PN}/hiscore.lst

	insinto "${GAMES_SYSCONFDIR}"/${PN}
	doins config.cfg

	prepgamesdirs
}
