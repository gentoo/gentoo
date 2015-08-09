# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

DESCRIPTION="tool for identifying where in the system latency is happening"
HOMEPAGE="http://www.latencytop.org/"
SRC_URI="http://www.latencytop.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gtk unicode"

RDEPEND="=dev-libs/glib-2*
	gtk? ( =x11-libs/gtk+-2* )
	sys-libs/ncurses"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-*.patch
	sed -i \
		-e "/^HAS_GTK_GUI/s:=.*:=$(use gtk && echo 1):" \
		Makefile || die
}

src_compile() {
	tc-export CC PKG_CONFIG
	emake || die
}

src_install() {
	emake install DESTDIR="${D}" || die
}
