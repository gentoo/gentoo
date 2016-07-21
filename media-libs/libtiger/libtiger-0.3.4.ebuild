# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit libtool

DESCRIPTION="A rendering library for Kate streams using Pango and Cairo"
HOMEPAGE="https://code.google.com/p/libtiger/"
SRC_URI="https://libtiger.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="doc"

RDEPEND="x11-libs/pango
	>=media-libs/libkate-0.2.0
	x11-libs/cairo"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

src_prepare() {
	elibtoolize
}

src_configure() {
	econf $(use_enable doc) --docdir=/usr/share/doc/${PF}
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc THANKS README ChangeLog AUTHORS
	find "${ED}" -name '*.la' -exec rm -f {} +
}
