# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils games

DESCRIPTION="A Conway's Life simulator for Unix"
HOMEPAGE="http://ironphoenix.org/tril/gtklife/"
SRC_URI="http://ironphoenix.org/tril/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ~ppc x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	dev-libs/glib:2
	x11-libs/libX11"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-link.patch
}

src_configure() {
	egamesconf \
		--with-gtk2 \
		--with-docdir=/usr/share/doc/${PF}/html
}

src_install() {
	dogamesbin ${PN}

	insinto "${GAMES_DATADIR}"/${PN}
	doins -r graphics patterns

	newicon icon_48x48.png ${PN}.png
	make_desktop_entry ${PN} GtkLife

	dohtml doc/*
	dodoc AUTHORS README NEWS
	prepgamesdirs
}
