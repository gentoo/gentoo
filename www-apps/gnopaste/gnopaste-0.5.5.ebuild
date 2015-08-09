# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit webapp eutils

DESCRIPTION="gnopaste is a nopaste script based on PHP with MySQL"
HOMEPAGE="http://gnopaste.sf.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="virtual/httpd-php
	dev-lang/php[mysql]"

need_httpd_cgi

src_prepare() {
	esvn_clean
}

src_install() {
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_configfile "${MY_HTDOCSDIR}"/config.php

	webapp_serverowned "${MY_HTDOCSDIR}"/config.php
	webapp_serverowned "${MY_HTDOCSDIR}"/install.php

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en-${PV}.txt

	webapp_src_install
}
