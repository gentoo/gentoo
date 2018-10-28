# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user webapp

DESCRIPTION="Textpattern a free CMS based on PHP and MySQL"
HOMEPAGE="https://textpattern.com"
SRC_URI="https://textpattern.com/File+download/86/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="+apache -nginx"
REQUIRED_USE="|| ( apache nginx )"

RDEPEND=">=virtual/mysql-5.5
	nginx? ( >www-servers/nginx-1.13 )
	apache? ( >=www-servers/apache-2.4 www-apache/mod_security )
	|| ( dev-lang/php[apache2,mysql,mysqli] dev-lang/php[apache2,mysql,pdo] )"

pkg_setup() {
	webapp_pkg_setup
}

src_install() {
	webapp_src_preinst

	local docs="README.txt"
	dodoc ${docs}

	touch "${S}"/textpattern/config.php
	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_configfile "${MY_HTDOCSDIR}"/textpattern/config-dist.php
	webapp_configfile "${MY_HTDOCSDIR}"/textpattern/config.php

	webapp_src_install
}

pkg_postinst() {
	elog "Textpattern has been installed in ${MY_HTDOCSDIR}."
	elog "Please make sure that you have your database set up."
	elog "Follow the setup instructions at 'http://yoursite/textpattern/setup' to get everything set up."
	elog "Consult ${MY_HTDOCSDIR}/README.txt for further details."
}
