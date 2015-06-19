# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/pam_ldap/pam_ldap-186.ebuild,v 1.3 2013/05/04 03:47:12 naota Exp $

inherit eutils pam

DESCRIPTION="PAM LDAP Module"
HOMEPAGE="http://www.padl.com/OSS/pam_ldap.html"
SRC_URI="http://www.padl.com/download/${P}.tar.gz"

LICENSE="|| ( GPL-2 LGPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="ssl sasl"
DEPEND="|| ( >=sys-libs/glibc-2.1.3 >=sys-freebsd/freebsd-lib-9.1 )
		virtual/pam
		>=net-nds/openldap-2.1.30-r5
		sasl? ( dev-libs/cyrus-sasl )"

src_unpack() {
	unpack ${A}

	cd "${S}"
}

src_compile() {
	econf --with-ldap-lib=openldap `use_enable ssl` || die
	emake || die
}

src_install() {
	dopammod pam_ldap.so

	dodoc pam.conf ldap.conf ldapns.schema chsh chfn certutil
	dodoc ChangeLog CVSVersionInfo.txt README AUTHORS ns-pwd-policy.schema
	doman pam_ldap.5

	docinto pam.d
	dodoc pam.d/*
}
