# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils

DESCRIPTION="Samba LDAP management tools"
HOMEPAGE="https://gna.org/projects/smbldap-tools/"
SRC_URI="http://download.gna.org/smbldap-tools/sources/${PV}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE=""

RDEPEND="
	dev-perl/perl-ldap
	dev-perl/Crypt-SmbHash
	dev-perl/Digest-SHA1
	dev-perl/Unicode-MapUTF8
	dev-perl/IO-Socket-SSL
	net-nds/openldap
	net-fs/samba
"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-smbldap-config-pod.patch
}

src_install() {
	default

	newsbin smbldap-config.cmd smbldap-config
	dosym smbldap-passwd /usr/sbin/smbldap-passwd.cmd

	dodoc CONTRIBUTORS ChangeLog FILES INFRA INSTALL README TODO doc/*conf* doc/smbldap-tools*
	dodoc -r doc/migration_scripts

	sed -i 's/.CMD//g' smbldap-[gpu]*.8 || die
	doman smbldap-[gpu]*.8

	insinto /etc/smbldap-tools
	doins smbldap.conf smbldap_bind.conf

	elog "Remember to read INSTALL when updating."
}

pkg_postinst() {
	elog "- A good howto is found on http://download.gna.org/smbldap-tools/docs/samba-ldap-howto/"
	elog "  and http://download.gna.org/smbldap-tools/docs/smbldap-tools/"
	elog "- The configure script is installed as smbldap-configure.pl. Please run it to configure the tools."
	elog "- Examples configuration files for Samba and slapd have been copied to ${EPREFIX}/usr/share/doc/${PF},"
	elog "  together with the migration-scripts."
	elog "- Also remember to read INSTALL when updating."
}
