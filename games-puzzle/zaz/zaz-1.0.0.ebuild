# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/zaz/zaz-1.0.0.ebuild,v 1.8 2014/06/13 15:50:01 mr_bones_ Exp $

EAPI=5
inherit autotools flag-o-matic eutils games

DESCRIPTION="A puzzle game where the player has to arrange balls in triplets"
HOMEPAGE="http://sourceforge.net/projects/zaz/"
SRC_URI="mirror://sourceforge/zaz/${P}.tar.bz2"

LICENSE="GPL-3 GPL-3+ CC-BY-SA-3.0 OFL"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

RDEPEND="virtual/opengl
	virtual/glu
	media-libs/libsdl[X,sound,video]
	media-libs/sdl-image[jpeg,png]
	media-libs/libvorbis
	media-libs/libtheora
	media-libs/ftgl
	virtual/libintl"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	local x=/usr/share/gettext/po/Makefile.in.in
	[[ -e $x ]] && cp -f $x po/ #336119

	epatch "${FILESDIR}"/${P}-build.patch
	eautoreconf
}

src_configure() {
	append-libs -lvorbis
	append-cflags $(pkg-config sdl --cflags)
	append-cxxflags $(pkg-config sdl --cflags)
	egamesconf \
		--disable-dependency-tracking \
		--with-applicationdir=/usr/share/applications \
		--with-icondir=/usr/share/pixmaps \
		--localedir=/usr/share/locale \
		$(use_enable nls)
}

src_install() {
	default
	prepgamesdirs
}
