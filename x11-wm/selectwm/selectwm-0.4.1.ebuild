# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

DESCRIPTION="window manager selector tool"
HOMEPAGE="http://ordiluc.net/selectwm"
SRC_URI="http://ordiluc.net/selectwm/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="amd64 ppc sparc x86 ~x86-fbsd"
IUSE="nls"

RDEPEND="x11-libs/gtk+:2
	dev-libs/glib:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-enable-deprecated-gtk.patch \
		"${FILESDIR}"/${P}-glibc-2.10.patch \
		"${FILESDIR}"/${P}-nostrip.patch
	eautoreconf
}

src_configure() {
	econf \
		--program-suffix=2 \
		$(use_enable nls)
}

src_install () {
	emake DESTDIR="${D}" install
	dodoc AUTHORS README sample.xinitrc
}
