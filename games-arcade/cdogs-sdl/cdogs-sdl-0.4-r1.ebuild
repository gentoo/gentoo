# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic games

CDOGS_DATA="cdogs-data-2007-07-06"
DESCRIPTION="A port of the old DOS arcade game C-Dogs"
HOMEPAGE="http://lumaki.com/code/cdogs"
SRC_URI="http://icculus.org/cdogs-sdl/files/src/${P}.tar.bz2
	http://icculus.org/cdogs-sdl/files/data/${CDOGS_DATA}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-libs/libsdl[video]
	media-libs/sdl-mixer"
RDPEND=${DEPEND}

S=${WORKDIR}/${P}/src

src_unpack() {
	unpack ${A}
	mv ${CDOGS_DATA} ${P}/data || die
}

src_prepare() {
	sed -i \
		-e "/^CF_OPT/d" \
		-e "/^CC/d" \
		Makefile || die
	sed -i -e "/\bopen(/s/)/, 0666)/" files.c || die
	epatch "${FILESDIR}"/${P}-64bit.patch
	append-cflags -std=gnu89 # build with gcc5 (bug #571112)
}

src_compile() {
	emake I_AM_CONFIGURED=yes \
		SYSTEM="\"linux\"" \
		STRIP=true \
		DATADIR="${GAMES_DATADIR}/${PN}" \
		cdogs
}

src_install() {
	dogamesbin cdogs
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r ../data/*
	newicon ../data/cdogs_icon.png ${PN}.png
	dodoc ../doc/{README,AUTHORS,ChangeLog,README_DATA,TODO,original_readme.txt}
	make_desktop_entry "cdogs -fullscreen" C-Dogs
	prepgamesdirs
}
