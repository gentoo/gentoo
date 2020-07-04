# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A nearly complete nss/shadow suite for managing POSIX users/groups/data in LDAP"
#HOMEPAGE="http://research.iat.sfu.ca/custom-software/diradm/"
#SRC_URI="http://research.iat.sfu.ca/custom-software/diradm/${P}.tar.bz2"
HOMEPAGE="http://orbis-terrarum.net/~robbat2/"
SRC_URI="http://orbis-terrarum.net/~robbat2/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="automount irixpasswd samba test"
RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( automount irixpasswd samba )"

RDEPEND=">=net-nds/openldap-2.3
	sys-apps/gawk
	sys-apps/coreutils
	sys-apps/grep
	dev-lang/perl
	app-shells/bash:*
	sys-apps/sed
	virtual/perl-MIME-Base64
	samba? (
		dev-perl/Crypt-SmbHash
		>=net-fs/samba-3.0.6
	)"
DEPEND="
	${RDEPEND}
	test? (
		dev-perl/Crypt-SmbHash
		>=net-fs/samba-3.0.6
		dev-util/dejagnu
		net-nds/openldap[-minimal]
	)"

src_configure() {
	econf \
		$(use_enable automount) \
		$(use_enable irixpasswd) \
		$(use_enable samba)
}

src_test() {
	emake -j1 check
}

src_install() {
	default
	dodoc CHANGES.prefork KNOWN-BUGS

	if use irixpasswd; then
		insinto /etc/openldap/schema
		doins irixpassword.schema
	fi
}

pkg_postinst() {
	elog "The new diradm pulls many settings from your LDAP configuration."
	elog "But don't forget to customize /etc/diradm.conf for other settings."
	elog "Please see the README to instructions if you problems."
	elog "This package is primarily intended for use with nss_ldap & pam_ldap"
	elog "and populates many default settings from the /etc/ldap.conf used by"
	elog "those packages, with a further fallback to /etc/openldap/ldap.conf"
	elog "for server connection settings only."
}
