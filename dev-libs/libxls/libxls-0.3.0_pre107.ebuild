# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools

DESCRIPTION="A library which can read Excel (xls) files"
HOMEPAGE="http://libxls.sourceforge.net/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="virtual/libintl
	!<app-text/catdoc-0.94.2-r2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		--disable-static
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS TODO
	dohtml doc/homepage/*.{css,html}
	find "${ED}" -name '*.la' -delete || die
}
