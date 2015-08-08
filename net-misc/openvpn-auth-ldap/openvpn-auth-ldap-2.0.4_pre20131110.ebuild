# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils autotools flag-o-matic

DESCRIPTION="LDAP authentication and authorization plugin for OpenVPN 2.x"
HOMEPAGE="https://code.google.com/p/openvpn-auth-ldap/"
SRC_URI="http://dev.gentoo.org/~ercpe/distfiles/${CATEGORY}/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND="net-misc/openvpn
	net-nds/openldap"
DEPEND="dev-util/re2c
	sys-devel/gcc[objc]
	${RDEPEND}"

S="${WORKDIR}/${P}"

src_prepare() {
	sed \
		-e '/test/d' \
		-i Makefile.in || die
	epatch \
		"${FILESDIR}"/${PV}-objc.patch \
		"${FILESDIR}"/${PV}-gentoo.patch
	eautoreconf
}

src_configure() {
	econf \
		--with-openvpn="${EPREFIX}/usr/include" \
		--with-openldap="${EPREFIX}/usr/include" \
		--with-objc-runtime=GNU
}

src_compile() {
	emake -C tools
	emake -C src TRConfigParser.h
	default
}

src_install() {
	default
	dodoc auth-ldap.conf
}
