# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/xbomber/xbomber-101.ebuild,v 1.17 2015/01/02 11:23:29 tupone Exp $

EAPI=4
inherit eutils games

DESCRIPTION="Bomberman clone w/multiplayer support"
HOMEPAGE="http://www.xdr.com/dash/bomber.html"
SRC_URI="http://www.xdr.com/dash/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="x11-libs/libX11"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i \
		-e "/^CC/d" \
		-e 's/gcc/$(CC)/g' \
		-e "s:X386:X11R6:" \
		Makefile \
		|| die "sed failed"
	sed -i \
		-e "s:data/%s:${GAMES_DATADIR}/${PN}/%s:" bomber.c \
		|| die "sed failed"
	sed -i \
		-e "s:=\"data\":=\"${GAMES_DATADIR}/${PN}\":" sound.c \
		|| die "sed failed"
	epatch \
		"${FILESDIR}"/${P}-va_list.patch \
		"${FILESDIR}"/${P}-gcc4.patch \
		"${FILESDIR}"/${P}-ldflags.patch
}

src_install() {
	dogamesbin matcher bomber
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r data/*
	dodoc README Changelog
	prepgamesdirs
}
