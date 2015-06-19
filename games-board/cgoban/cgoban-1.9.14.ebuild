# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/cgoban/cgoban-1.9.14.ebuild,v 1.12 2014/10/30 16:52:52 mr_bones_ Exp $

EAPI=5
inherit eutils autotools games

DESCRIPTION="A Go-frontend"
HOMEPAGE="http://cgoban1.sourceforge.net/"
SRC_URI="mirror://sourceforge/cgoban1/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="
	|| (
		media-gfx/imagemagick
		media-gfx/graphicsmagick[imagemagick]
	)
	x11-libs/libX11
	x11-libs/libXt"
DEPEND="${RDEPEND}
	x11-proto/xproto"

src_prepare() {
	cp cgoban_icon.png ${PN}.png || die
	mv configure.{in,ac} || die
	epatch "${FILESDIR}"/${P}-cflags.patch
	eautoreconf
}

src_install() {
	default
	doicon ${PN}.png
	make_desktop_entry cgoban Cgoban
	prepgamesdirs
}
