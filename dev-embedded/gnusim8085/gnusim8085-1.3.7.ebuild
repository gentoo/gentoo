# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils autotools

DESCRIPTION="A GTK2 8085 Simulator"
HOMEPAGE="http://gnusim8085.org"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls examples"

RDEPEND=">=x11-libs/gtk+-2.12:2
	x11-libs/gdk-pixbuf:2
	dev-libs/glib:2
	x11-libs/gtksourceview:2.0
	x11-libs/pango"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-docs.patch
	epatch "${FILESDIR}"/${P}-cflags.patch
	eautoreconf
}

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	default
	doman doc/gnusim8085.1

	if use examples ; then
		docompress -x /usr/share/doc/${PF}/examples
		insinto /usr/share/doc/${PF}/examples
		doins doc/examples/*.asm doc/asm-guide.txt
	fi
}
