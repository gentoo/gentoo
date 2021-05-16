# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop

DESCRIPTION="An entertaining game based on the old DOS game lines"
HOMEPAGE="http://gtkballs.antex.ru/"
SRC_URI="http://gtkballs.antex.ru/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="
	x11-libs/gtk+:2
	nls? ( virtual/libintl )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( >=sys-devel/gettext-0.10.38 )
"

src_prepare() {
	default
	sed -i \
		-e '/^nlsdir=/s:=.*:=/usr/share/locale:' \
		-e '/^localedir/s:=.*:=/usr/share/locale:' \
		configure po/Makefile.in.in || die "sed locale failed"
}

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	default
	newicon gnome-gtkballs.png ${PN}.png
	make_desktop_entry gtkballs "GTK Balls"
}
