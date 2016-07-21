# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils games

DESCRIPTION="puzzle game inspired by Atomix and written in SDL"
HOMEPAGE="http://lgames.sourceforge.net/index.php?project=LMarbles"
SRC_URI="mirror://sourceforge/lgames/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="media-libs/libsdl[video]
	media-libs/sdl-mixer"
RDEPEND="${DEPEND}"

src_prepare() {
	mv configure.{in,ac}
	rm *.m4
	epatch "${FILESDIR}"/${P}-gentoo.patch
	eautoreconf
}

src_install() {
	default
	newicon lmarbles48.gif ${PN}.gif
	make_desktop_entry lmarbles LMarbles /usr/share/pixmaps/${PN}.gif
	dohtml src/manual/*
	prepgamesdirs
}
