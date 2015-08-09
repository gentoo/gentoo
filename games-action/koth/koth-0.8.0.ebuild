# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=4
inherit eutils games

DESCRIPTION="Multiplayer, networked game of little tanks with really big weapons"
HOMEPAGE="http://www.nongnu.org/koth/"
SRC_URI="http://savannah.nongnu.org/download/${PN}/default.pkg/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc x86 ~x86-fbsd"
IUSE=""

DEPEND="media-libs/libggi"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i 's:-g -O2::' configure \
		|| die "sed configure failed"
	cd src
	epatch "${FILESDIR}"/${P}-gcc-3.4.patch
	sed -i "s:/etc/koth:${GAMES_SYSCONFDIR}:" cfgfile.h \
		|| die "sed cfgfile.h failed"
	sed -i 's:(uint16):(uint16_t):' gfx.c gfx.h \
		|| die "sed gfx.c gfx.h failed"
}

DOCS="AUTHORS ChangeLog NEWS README doc/*.txt"

src_install() {
	default
	insinto "${GAMES_SYSCONFDIR}"
	doins src/koth.cfg
	prepgamesdirs
}
