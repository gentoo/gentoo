# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/xbomb/xbomb-2.2a.ebuild,v 1.7 2015/02/27 20:20:12 tupone Exp $

EAPI=5
inherit eutils games

DESCRIPTION="Minesweeper clone with hexagonal, rectangular and triangular grid"
HOMEPAGE="http://www.gedanken.demon.co.uk/xbomb/"
SRC_URI="http://www.gedanken.demon.co.uk/download-xbomb/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

DEPEND="x11-libs/libXaw"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-DESTDIR.patch \
		"${FILESDIR}"/${P}-ldflags.patch
	sed -i \
		-e '/strip/d' \
		-e "/^CFLAGS/ { s:=.*:=${CFLAGS}: }" \
		-e "s:/usr/bin:${GAMES_BINDIR}:" \
		Makefile \
		|| die "sed Makefile failed"
	sed -i \
		-e "s:/var/tmp:${GAMES_STATEDIR}/${PN}:g" \
		hiscore.c \
		|| die "sed hiscore.c failed"
}

src_install() {
	default
	dodoc LSM
	dodir "${GAMES_STATEDIR}"/${PN}
	touch "${D}/${GAMES_STATEDIR}"/${PN}/${PN}{3,4,6}.hi || die "touch failed"
	fperms 660 "${GAMES_STATEDIR}"/${PN}/${PN}{3,4,6}.hi
	prepgamesdirs
}
