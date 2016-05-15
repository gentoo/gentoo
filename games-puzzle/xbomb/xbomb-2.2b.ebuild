# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="Minesweeper clone with hexagonal, rectangular and triangular grid"
HOMEPAGE="http://www.gedanken.org.uk/software/xbomb/"
SRC_URI="http://www.gedanken.org.uk/software/xbomb/download/${P}.tgz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

DEPEND="x11-libs/libXaw"
RDEPEND=${DEPEND}

src_prepare() {
	epatch "${FILESDIR}"/${P}-DESTDIR.patch \
		"${FILESDIR}"/${P}-ldflags.patch
	sed -i \
		-e '/strip/d' \
		-e '/^CC=/d' \
		-e "/^CFLAGS/ { s:=.*:=${CFLAGS}: }" \
		-e "s:/usr/bin:${GAMES_BINDIR}:" \
		Makefile || die
	sed -i \
		-e "s:/var/tmp:${GAMES_STATEDIR}/${PN}:g" \
		hiscore.c || die
}

src_install() {
	default
	dodir "${GAMES_STATEDIR}"/${PN}
	touch "${D}/${GAMES_STATEDIR}"/${PN}/${PN}{3,4,6}.hi || die "touch failed"
	fperms 660 "${GAMES_STATEDIR}"/${PN}/${PN}{3,4,6}.hi
	make_desktop_entry xbomb XBomb
	prepgamesdirs
}
