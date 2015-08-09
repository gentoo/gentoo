# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="an OpenGL car racing game, based on ID's famous Quake engine"
HOMEPAGE="http://miniracer.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

RDEPEND="virtual/opengl
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXxf86dga
	x11-libs/libXxf86vm
	media-libs/libsdl
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}
	x11-proto/xf86dgaproto
	x11-proto/xf86vidmodeproto
	x11-proto/xproto"

src_prepare() {
	epatch "${FILESDIR}"/${P}-nosharedelf.patch \
		"${FILESDIR}"/${P}-ldflags.patch
	sed -i \
		-e "s:@CFLAGS@:${CFLAGS}:" \
		-e "s:@GAMES_LIBDIR@:$(games_get_libdir)/${PN}:" \
		-e "s:@GAMES_BINDIR@:${GAMES_BINDIR}:" \
		miniracer Makefile || die
}

src_install() {
	default
	prepgamesdirs
}
