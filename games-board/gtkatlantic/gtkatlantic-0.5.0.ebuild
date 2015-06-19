# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/gtkatlantic/gtkatlantic-0.5.0.ebuild,v 1.4 2015/02/21 12:20:05 ago Exp $

EAPI=5
inherit eutils gnome2-utils games

DESCRIPTION="Monopoly-like game that works with the monopd server"
HOMEPAGE="http://gtkatlantic.gradator.net/"
SRC_URI="http://download.tuxfamily.org/gtkatlantic/downloads/v0.5/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="x11-libs/gtk+:3
	dev-libs/libxml2
	media-libs/libpng:0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	default
	newicon data/icon32x32.xpm ${PN}.xpm
	newicon -s 16 data/icon16x16.xpm ${PN}.xpm
	newicon -s 32 data/icon32x32.xpm ${PN}.xpm
	make_desktop_entry ${PN} GtkAtlantic
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
