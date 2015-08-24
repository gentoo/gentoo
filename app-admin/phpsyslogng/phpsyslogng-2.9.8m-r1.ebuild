# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit webapp

DESCRIPTION="php-syslog-ng is a log monitor designed to easily manage logs from many hosts"
HOMEPAGE="https://php-syslog-ng.googlecode.com/"
SRC_URI="https://php-syslog-ng.googlecode.com/files/php-syslog-ng-${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="mysql"

RDEPEND="virtual/httpd-php
		mysql? ( >=virtual/mysql-4.1 )"

src_install() {
	webapp_src_preinst

	dodoc html/README html/CHANGELOG \
		html/INSTALL-STEPS \
		html/TROUBLESHOOTING-INSTALL
	rm html/LICENSE html/README \
		html/CHANGELOG html/INSTALL-STEPS \
		html/TROUBLESHOOTING-INSTALL
	insinto /usr/share/doc/${PF}
	doins -r scripts/*

	insinto "${MY_HTDOCSDIR}"
	doins -r ./html/{.htaccess,*}

	webapp_configfile "${MY_HTDOCSDIR}/config/config.php"

	webapp_serverowned -R "${MY_HTDOCSDIR}/config/"
	webapp_serverowned -R "${MY_HTDOCSDIR}/jpcache/"

	webapp_postinst_txt en "${FILESDIR}/postinstall-en.txt"

	webapp_src_install
}
