# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/bomns/bomns-0.99.2.ebuild,v 1.7 2015/01/03 18:27:47 tupone Exp $

EAPI=4
inherit autotools flag-o-matic games

DESCRIPTION="A fast-paced multiplayer deathmatch arcade game"
HOMEPAGE="http://greenridge.sourceforge.net"
SRC_URI="mirror://sourceforge/greenridge/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE="gtk editor"

DEPEND="media-libs/libsdl[video]
	media-libs/sdl-mixer
	gtk? ( x11-libs/gtk+:2 )"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i \
		-e "/appicondir/s:\$(prefix):/usr:" \
		-e "/desktopdir/s:\$(prefix):/usr:" \
		$(find icons -name Makefile.am) \
		Makefile.am \
		|| die "sed failed"
	sed -i \
		-e "s:\$*[({]prefix[})]/share:${GAMES_DATADIR}:" \
		configure.in \
		graphics/Makefile.am \
		levels/Makefile.am \
		sounds/Makefile.am \
		|| die "sed failed"
	epatch "${FILESDIR}"/${P}-fpe.patch
	eautoreconf
}

src_configure() {
	filter-flags -fforce-addr
	egamesconf \
		--disable-dependency-tracking \
		--disable-launcher1 \
		$(use_enable gtk launcher2) \
		$(use_enable editor)
}

src_install() {
	default
	prepgamesdirs
}
