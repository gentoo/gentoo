# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

DESCRIPTION="A GTK 8085 Simulator"
HOMEPAGE="https://gnusim8085.srid.ca/ https://github.com/GNUSim8085/GNUSim8085"
SRC_URI="https://github.com/GNUSim8085/GNUSim8085/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="
	dev-libs/glib:2
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/gtksourceview:3.0=
	x11-libs/pango
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/discount
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	default

	doman doc/gnusim8085.1

	docinto examples
	dodoc doc/examples/*.asm doc/asm-guide.txt
	docompress -x /usr/share/doc/${PF}/examples
}
