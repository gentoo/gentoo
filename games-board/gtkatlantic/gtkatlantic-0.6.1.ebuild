# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils gnome2-utils games

DESCRIPTION="Monopoly-like game that works with the monopd server"
HOMEPAGE="http://gtkatlantic.gradator.net/"
SRC_URI="http://download.tuxfamily.org/gtkatlantic/downloads/v0.6/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="x11-libs/gtk+:3
	dev-libs/libxml2
	media-libs/libpng:0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	sed -i -e 's:$(datadir):/usr/share:' {,data/}Makefile.am || die
	sed -i -e 's/configure.in/configure.ac/' configure.in || die
	mv configure.{in,ac} || die
	epatch "${FILESDIR}"/${P}-warnings.patch
	eautoreconf
}

src_configure() {
	egamesconf \
		--with-icons-path=/usr/share/icons/hicolor
}

src_install() {
	default
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
