# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools eutils gnome2-utils

DESCRIPTION="Monopoly-like game that works with the monopd server"
HOMEPAGE="http://gtkatlantic.gradator.net/"
SRC_URI="http://download.tuxfamily.org/gtkatlantic/downloads/v0.6/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="
	dev-libs/libxml2
	media-libs/libpng:0
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-warnings.patch
)

src_prepare() {
	default

	sed -i -e 's:$(datadir):/usr/share:' {,data/}Makefile.am || die
	sed -i -e 's/configure.in/configure.ac/' configure.in || die
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf \
		--with-icons-path=/usr/share/icons/hicolor
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
