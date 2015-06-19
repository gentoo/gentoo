# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/pdns-ldap-backend/pdns-ldap-backend-0.2.ebuild,v 1.2 2014/08/10 20:42:40 slyfox Exp $

EAPI=5

inherit autotools eutils multilib

DESCRIPTION="Fork of the official but unmaintained LDAP backend"
HOMEPAGE="http://repo.or.cz/w/pdns-ldap-backend.git http://sequanux.org/cgi-bin/mailman/listinfo/pdns-ldap-backend"
SRC_URI="http://sequanux.org/dl/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="sasl"

DEPEND=">=net-dns/pdns-3.2[-ldap]
	net-nds/openldap[sasl=]
	virtual/krb5"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		--with-pdns="${EPREFIX}/usr/include" \
		--libdir=/usr/$(get_libdir)/powerdns
}

src_install() {
	DOCS="AUTHORS ChangeLog NEWS README USAGE* src/dns.ldif"
	default
	prune_libtool_files --all
	insinto /etc/openldap/schema
	doins schema/*
}
