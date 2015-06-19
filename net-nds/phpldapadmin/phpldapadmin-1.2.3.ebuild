# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nds/phpldapadmin/phpldapadmin-1.2.3.ebuild,v 1.3 2014/08/10 20:53:27 slyfox Exp $

EAPI=5

inherit webapp depend.php

DESCRIPTION="phpLDAPadmin is a web-based tool for managing all aspects of your LDAP server"
HOMEPAGE="http://phpldapadmin.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="dev-lang/php[hash,ldap,session,xml,nls]
		 || ( <dev-lang/php-5.3[pcre] >=dev-lang/php-5.3 )"

need_httpd_cgi
need_php_httpd

src_prepare() {
	mv config/config.php.example config/config.php
	epatch "${FILESDIR}/${PN}-1.2.1.1-fix-magic-quotes.patch"
	# http://phpldapadmin.git.sourceforge.net/git/gitweb.cgi?p=phpldapadmin/phpldapadmin;a=commit;h=7dc8d57d6952fe681cb9e8818df7f103220457bd
}

src_install() {
	webapp_src_preinst

	dodoc INSTALL

	# Restrict config file access - bug 280836
	chown root:apache "config/config.php"
	chmod 640 "config/config.php"

	insinto "${MY_HTDOCSDIR}"
	doins -r *

	webapp_configfile "${MY_HTDOCSDIR}/config/config.php"
	webapp_postinst_txt en "${FILESDIR}"/postinstall2-en.txt

	webapp_src_install
}
