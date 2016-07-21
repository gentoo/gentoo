# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic games

DESCRIPTION="Multiplayer, networked game of little tanks with really big weapons"
HOMEPAGE="http://www.nongnu.org/koth/"
SRC_URI="https://savannah.nongnu.org/download/${PN}/default.pkg/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc x86 ~x86-fbsd"
IUSE=""

DEPEND="media-libs/libggi"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i 's:-g -O2::' configure || die
	cd src
	epatch "${FILESDIR}"/${P}-gcc-3.4.patch
	sed -i "s:/etc/koth:${GAMES_SYSCONFDIR}:" cfgfile.h || die
	sed -i 's:(uint16):(uint16_t):' gfx.c gfx.h || die
	append-cflags -std=gnu89 # build with gcc5 (bug #570730)
}

src_install() {
	DOCS="AUTHORS ChangeLog NEWS README doc/*.txt" \
		default
	insinto "${GAMES_SYSCONFDIR}"
	doins src/koth.cfg
	prepgamesdirs
}
