# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit webapp

MY_PN="phpLDAPadmin"
DESCRIPTION="phpLDAPadmin is a web-based tool for managing all aspects of your LDAP server"
HOMEPAGE="http://phpldapadmin.sourceforge.net"
SRC_URI="https://github.com/leenooks/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="
	>=dev-lang/php-5.5[hash(+),ldap,session,xml,nls]
	virtual/httpd-php
"
S="${WORKDIR}/${MY_PN}-${PV}"

# http://phpldapadmin.git.sourceforge.net/git/gitweb.cgi?p=phpldapadmin/phpldapadmin;a=commit;h=7dc8d57d6952fe681cb9e8818df7f103220457bd
PATCHES=(
	"${FILESDIR}/${PN}-1.2.1.1-fix-magic-quotes.patch"
)

need_httpd_cgi

src_prepare() {
	mv config/config.php.example config/config.php
	default
}

src_install() {
	webapp_src_preinst

	dodoc INSTALL.md

	# Restrict config file access - bug 280836
	chown root:apache "config/config.php"
	chmod 640 "config/config.php"

	insinto "${MY_HTDOCSDIR}"
	doins -r *

	webapp_configfile "${MY_HTDOCSDIR}/config/config.php"
	webapp_postinst_txt en "${FILESDIR}"/postinstall2-en.txt

	webapp_src_install
}
