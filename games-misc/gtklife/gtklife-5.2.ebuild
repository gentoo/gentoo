# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg

DESCRIPTION="A Conway's Life simulator for Unix"
HOMEPAGE="http://ironphoenix.org/tril/gtklife/"
SRC_URI="http://ironphoenix.org/tril/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2
	x11-libs/libX11"

DEPEND="
	${RDEPEND}
"

BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	econf \
		--with-gtk2 \
		--with-docdir=/usr/share/doc/${PF}/html
}

src_install() {
	dobin ${PN}

	insinto /usr/share/${PN}
	doins -r graphics patterns

	newicon -s 48 icon_48x48.png ${PN}.png
	make_desktop_entry ${PN} GtkLife

	dodoc -r doc/*
	dodoc AUTHORS README NEWS
}
