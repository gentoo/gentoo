# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/battalion/battalion-1.4b.ebuild,v 1.18 2015/03/30 22:36:05 mr_bones_ Exp $

EAPI=5
inherit eutils games

DESCRIPTION="Be a rampaging monster and destroy the city"
HOMEPAGE="http://evlweb.eecs.uic.edu/aej/AndyBattalion.html"
SRC_URI="http://evlweb.eecs.uic.edu/aej/BATTALION/${PN}${PV}.tar.bz2"

LICENSE="battalion HPND"
SLOT="0"
KEYWORDS="ppc x86"
IUSE=""

DEPEND="virtual/opengl
	virtual/glu
	x11-libs/libX11"
RDEPEND=${DEPEND}

S=${WORKDIR}/${PN}${PV}

src_prepare() {
	epatch "${FILESDIR}"/${P}-warning.patch
	# Modify data paths
	sed -i \
		-e "s:SOUNDS/:${GAMES_DATADIR}/${PN}/SOUNDS/:" \
		-e "s:MUSIC/:${GAMES_DATADIR}/${PN}/MUSIC/:" \
		audio.c || die
	sed -i \
		-e "s:DATA/:${GAMES_DATADIR}/${PN}/DATA/:" \
		-e "s:/usr/tmp:${GAMES_STATEDIR}:" \
		battalion.c || die
	sed -i \
		-e "s:TEXTURES/:${GAMES_DATADIR}/${PN}/TEXTURES/:" \
		graphics.c || die

	# Modify Makefile and add CFLAGS
	sed -i \
		-e "s:-O2:${CFLAGS}:" \
		-e "/^CC/d" \
		Makefile || die
	# Only .raw sound files are used on Linux. The .au files are not needed.
	rm -f {SOUNDS,MUSIC}/*.au
}

src_compile() {
	emake LIBFLAGS="${LDFLAGS}"
}

src_install() {
	dogamesbin battalion
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r DATA MUSIC SOUNDS TEXTURES
	dodoc README

	dodir "${GAMES_STATEDIR}"
	touch "${D}${GAMES_STATEDIR}"/battalion_hiscore
	fperms 660 "${GAMES_STATEDIR}"/battalion_hiscore

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "Sound and music are not enabled by default."
	elog "Use the S and M keys to enable them in-game, or start the game with"
	elog "the -s and -m switches: battalion -s -m"
}
