# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils games

DESCRIPTION="DJ Delorie's Ace of Penguins solitaire games"
HOMEPAGE="http://www.delorie.com/store/ace/"
SRC_URI="http://www.delorie.com/store/ace/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	media-libs/libpng:0"
DEPEND="${RDEPEND}
	x11-proto/xproto"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-no-xpm.patch \
		"${FILESDIR}"/${P}-libpng15.patch \
		"${FILESDIR}"/${P}-gold.patch \
		"${FILESDIR}"/${P}-CC.patch \
		"${FILESDIR}"/${P}-clang.patch
	eautoreconf
}

src_configure() {
	egamesconf \
		--disable-static \
		--program-prefix=ace-
}

src_install() {
	default
	dohtml docs/*
	newicon docs/as.gif ${PN}.gif
	cd "${D}${GAMES_BINDIR}" || die
	local p
	for p in *
	do
		make_desktop_entry $p "Ace ${p/ace-/}" /usr/share/pixmaps/${PN}.gif
	done
	prepgamesdirs
}
