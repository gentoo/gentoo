# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/lbreakout/lbreakout-010315.ebuild,v 1.10 2015/01/05 11:24:54 tupone Exp $
EAPI=5
inherit games

DESCRIPTION="Breakout clone written with the SDL library"
HOMEPAGE="http://lgames.sourceforge.net/"
SRC_URI="mirror://sourceforge/lgames/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=">=media-libs/libsdl-1.1.5"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i \
		-e '/^sdir=/s:$datadir/games:$datadir:' \
		-e '/^hdir=/s:/var/lib/games:$localstatedir:' \
		configure \
		|| die "sed failed"
}

src_install() {
	dodir "${GAMES_STATEDIR}"
	default
	dohtml lbreakout/manual/*
	prepgamesdirs
}
