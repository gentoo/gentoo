# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils games

DESCRIPTION="GTK+ MUD client with ANSI color, macros, timers, triggers, variables, and an easy scripting language"
HOMEPAGE="http://dw.nl.eu.org/mudix.html"
SRC_URI="http://dw.nl.eu.org/gmudix/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-as-needed.patch
	mv configure.in configure.ac || die
	rm -f missing || die
	eautoreconf
}

src_install() {
	dogamesbin src/${PN}
	dodoc AUTHORS ChangeLog README TODO doc/*txt
	prepgamesdirs
}
