# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils multilib toolchain-funcs

DESCRIPTION="A remote security scanner for Linux (nessus-libraries)"
HOMEPAGE="http://www.nessus.org/"
SRC_URI="ftp://ftp.nessus.org/pub/nessus/nessus-${PV}/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux"
IUSE="crypt debug static-libs"

# Hard dep on SSL since libnasl won't compile when this package is emerged -ssl.
DEPEND="
	dev-libs/openssl
	net-libs/libpcap"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-linking.patch

	sed -i -e "s:^\(LDFLAGS=\):\1 ${LDFLAGS}:g" nessus.tmpl.in || die
	sed -i -e '/sbindir/d' Makefile || die
}

src_configure() {
	tc-export CC
	econf \
		$(use_enable crypt cypher) \
		$(use_enable debug) \
		$(use_enable debug debug-ssl) \
		$(use_enable static-libs static) \
		--enable-shared \
		--with-ssl="${EPREFIX}/usr/$(get_libdir)" \
		--disable-nessuspcap
}

src_install() {
	default
	use static-libs || find "${ED}" -name '*.la' -delete
}
