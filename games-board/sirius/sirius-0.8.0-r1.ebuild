# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools eutils

DESCRIPTION="A program for playing the game of othello/reversi"
HOMEPAGE="http://sirius.bitvis.nu/"
SRC_URI="http://sirius.bitvis.nu/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="
	gnome-base/gconf:2
	gnome-base/libgnomecanvas
	gnome-base/libgnomeui
	x11-libs/gtk+:2
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${P}-format.patch
)

src_prepare() {
	default
	sed -i -e '/-g -O3/d' configure.in || die
	sed -i \
		-e '/Icon/s/\.png//' \
		-e '/Categories/s/Application;//' \
		sirius.desktop.in || die
	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	econf \
		--datadir=/usr/share \
		$(use_enable nls)
}

src_install() {
	default
}
