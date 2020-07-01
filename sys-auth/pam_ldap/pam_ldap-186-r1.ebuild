# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils multilib-minimal pam

DESCRIPTION="PAM LDAP Module"
HOMEPAGE="http://www.padl.com/OSS/pam_ldap.html"
SRC_URI="http://www.padl.com/download/${P}.tar.gz"

LICENSE="|| ( GPL-2 LGPL-2 )"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~mips ppc ppc64 sparc x86"
IUSE="ssl sasl"

DEPEND=">=sys-libs/glibc-2.1.3
	sys-libs/pam[${MULTILIB_USEDEP}]
	>=net-nds/openldap-2.4.38-r1[${MULTILIB_USEDEP}]
	sasl? ( >=dev-libs/cyrus-sasl-2.1.26-r3[${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}"

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
