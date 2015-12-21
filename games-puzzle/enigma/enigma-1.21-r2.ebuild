# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils gnome2-utils games

DESCRIPTION="puzzle game similar to Oxyd"
HOMEPAGE="http://www.nongnu.org/enigma/"
SRC_URI="mirror://sourceforge/enigma-game/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE="nls"

COMMON_DEPS="media-libs/sdl-ttf
	media-libs/libsdl[video]
	media-libs/sdl-mixer
	media-libs/sdl-image[jpeg,png]
	media-libs/libpng:0=
	sys-libs/zlib
	net-misc/curl
	|| ( >=dev-libs/xerces-c-3[icu] >=dev-libs/xerces-c-3[-icu,-iconv] )
	net-libs/enet:=
	nls? ( virtual/libintl )"
DEPEND="${COMMON_DEPS}
	sys-devel/gettext"
RDEPEND="${COMMON_DEPS}
	media-fonts/dejavu
	x11-misc/xdg-utils"

src_prepare() {
	cp /usr/share/gettext/config.rpath .
	epatch "${FILESDIR}"/${P}-build.patch
	sed -i \
		-e "s:DOCDIR:\"/usr/share/doc/${P}/html\":" \
		src/main.cc || die
	eautoreconf
}

src_configure() {
	egamesconf \
		--with-system-enet \
		$(use_enable nls)
}

src_install() {
	DOCS="ACKNOWLEDGEMENTS AUTHORS CHANGES README doc/HACKING" \
		default
	dosym \
		/usr/share/fonts/dejavu/DejaVuSansCondensed.ttf \
		"${GAMES_DATADIR}"/${PN}/fonts/DejaVuSansCondensed.ttf
	dosym \
		/usr/share/fonts/dejavu/DejaVuSans.ttf \
		"${GAMES_DATADIR}"/${PN}/fonts/vera_sans.ttf
	dohtml -r doc/*
	doman doc/enigma.6
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
