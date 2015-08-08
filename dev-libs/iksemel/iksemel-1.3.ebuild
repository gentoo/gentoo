# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit autotools eutils

DESCRIPTION="eXtensible Markup Language parser library designed for Jabber applications"
HOMEPAGE="http://code.google.com/p/iksemel"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="gnutls"

RDEPEND="gnutls? ( net-libs/gnutls )"
DEPEND="${RDEPEND}
		gnutls? ( virtual/pkgconfig )"

# http://code.google.com/p/iksemel/issues/detail?id=4
RESTRICT="test"

src_prepare() {
	epatch "${FILESDIR}/${P}-gnutls-2.8.patch"
	eautoreconf
}

src_configure() {
	econf $(use_with gnutls)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog HACKING NEWS README TODO
}
