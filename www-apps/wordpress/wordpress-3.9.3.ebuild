# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/wordpress/wordpress-3.9.3.ebuild,v 1.1 2014/11/22 02:00:49 radhermit Exp $

EAPI="5"

inherit webapp

DESCRIPTION="Wordpress php and mysql based content management system (CMS)"
HOMEPAGE="http://wordpress.org/"
SRC_URI="http://wordpress.org/${P/_rc/-RC}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="virtual/httpd-php
	|| ( dev-lang/php[mysql] dev-lang/php[mysqli] )"

S=${WORKDIR}/${PN}

need_httpd_cgi

src_install() {
	webapp_src_preinst

	dohtml readme.html
	rm readme.html license.txt || die

	[ -f wp-config.php ] || cp wp-config-sample.php wp-config.php

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_serverowned "${MY_HTDOCSDIR}"/index.php
	webapp_serverowned "${MY_HTDOCSDIR}"/wp-admin/menu.php
	webapp_serverowned "${MY_HTDOCSDIR}"

	webapp_configfile  "${MY_HTDOCSDIR}"/wp-config.php

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_postupgrade_txt en "${FILESDIR}"/postupgrade-en.txt

	webapp_src_install
}
