# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/pam_ldap/pam_ldap-186-r1.ebuild,v 1.12 2014/11/14 21:19:15 maekke Exp $

EAPI=5
inherit eutils multilib-minimal pam

DESCRIPTION="PAM LDAP Module"
HOMEPAGE="http://www.padl.com/OSS/pam_ldap.html"
SRC_URI="http://www.padl.com/download/${P}.tar.gz"

LICENSE="|| ( GPL-2 LGPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="ssl sasl"

DEPEND="|| ( >=sys-libs/glibc-2.1.3 >=sys-freebsd/freebsd-lib-9.1 )
	>=virtual/pam-0-r1[${MULTILIB_USEDEP}]
	>=net-nds/openldap-2.4.38-r1[${MULTILIB_USEDEP}]
	sasl? ( >=dev-libs/cyrus-sasl-2.1.26-r3[${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20140508-r7
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"

multilib_src_configure() {
	local myconf=(
		--with-ldap-lib=openldap
		$(use_enable ssl)
	)
	use sasl || myconf+=( ac_cv_header_sasl_sasl_h=no )

	ECONF_SOURCE=${S} \
	econf "${myconf[@]}"
}

multilib_src_compile() {
	PERL5LIB=${S} \
	emake
}

multilib_src_install() {
	dopammod pam_ldap.so
}

multilib_src_install_all() {
	dodoc pam.conf ldap.conf ldapns.schema chsh chfn certutil
	dodoc ChangeLog CVSVersionInfo.txt README AUTHORS ns-pwd-policy.schema
	doman pam_ldap.5

	docinto pam.d
	dodoc pam.d/*
}
