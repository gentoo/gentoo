# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="A tetris clone with multiplayer support"
HOMEPAGE="https://code.google.com/p/quadra/"
SRC_URI="https://quadra.googlecode.com/files/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libXxf86vm
	x11-libs/libXext
	media-libs/libpng:0
	sys-libs/zlib"
DEPEND="${RDEPEND}
	sys-devel/bc
	x11-proto/xextproto"

src_prepare() {
	sed -i \
		-e "/^libgamesdir:=/s:/games:/${PN}:" \
		-e "/^datagamesdir:=/s:/games:/${PN}:" \
		config/config.mk.in || die
}

src_install() {
	dogamesbin ${PN}
	insinto "${GAMES_DATADIR}"/${PN}
	doins ${PN}.res
	doicon images/${PN}.xpm
	make_desktop_entry ${PN} Quadra

	dodoc ChangeLog NEWS README
	dohtml help/*
	prepgamesdirs
}
