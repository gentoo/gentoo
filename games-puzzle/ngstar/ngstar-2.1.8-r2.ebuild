# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="NGStar is a clone of a HP48 game called dstar"
HOMEPAGE="http://freshmeat.net/projects/ngstar"
SRC_URI="mirror://gentoo//${P}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="sys-libs/ncurses:0
	sys-libs/gpm"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gentoo-path.patch \
		"${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-gcc47.patch \
		"${FILESDIR}"/${P}-ldflags.patch
	sed -i \
		-e "s:@GENTOO_DATA@:${GAMES_DATADIR}:" \
		-e "s:@GENTOO_BIN@:${GAMES_BINDIR}:" \
		-e "/^CPPFLAGS/s:+=:+= ${CXXFLAGS}:" \
		-e "/SILENT/d" \
		configure || die
}

src_configure() {
	./configure \
		--prefix "" \
		--without-fltk2 || die
}

src_install() {
	default
	prepgamesdirs
}
