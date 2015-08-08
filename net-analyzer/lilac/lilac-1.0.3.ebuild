# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils webapp depend.php

DESCRIPTION="Web-based configuration tool written to configure Nagios"
HOMEPAGE="http://www.lilacplatform.com"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-php/PEAR-PEAR-1.6.1
	>=net-analyzer/nagios-3.0
	>=virtual/mysql-5.0
	dev-lang/php[curl,json,mysql,pcntl,pdo,posix,simplexml]
"

need_php_httpd

src_install() {
	webapp_src_preinst

	dodoc INSTALL UPGRADING
	rm -f INSTALL UPGRADING

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_configfile "${MY_HTDOCSDIR}"/includes/lilac-conf.php.dist
	webapp_serverowned "${MY_HTDOCSDIR}"/includes/lilac-conf.php.dist
	webapp_src_install
}
