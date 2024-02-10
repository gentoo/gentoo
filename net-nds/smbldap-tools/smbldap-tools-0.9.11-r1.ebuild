# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Samba LDAP management tools"
HOMEPAGE="https://github.com/fumiyas/smbldap-tools"
SRC_URI="https://github.com/fumiyas/smbldap-tools/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	dev-perl/perl-ldap
	dev-perl/Crypt-SmbHash
	dev-perl/Digest-SHA1
	dev-perl/Unicode-MapUTF8
	dev-perl/IO-Socket-SSL"

src_prepare() {
	default
	eautoreconf
	# Command from build/autogen.sh
	sed -n \
		-e "s/^/ /;s/$/ /;s/'/ ' /" \
		-e "/^ ac_subst_vars=/,/'/s/^.* \([A-Za-z_][A-Za-z0-9_]*\) .*/\1=@\1@/p" \
		configure > build/subst.vars.in || die
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
	elog "- The configure script is installed as smbldap-configure.pl. Please run it to configure the tools."
	elog "- Examples configuration files for Samba and slapd have been copied to ${EPREFIX}/usr/share/doc/${PF},"
	elog "  together with the migration-scripts."
	elog "- Also remember to read INSTALL when updating."
}
