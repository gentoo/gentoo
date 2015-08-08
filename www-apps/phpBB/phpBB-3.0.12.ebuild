# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit webapp

DESCRIPTION="phpBB is an open-source bulletin board package"
HOMEPAGE="http://www.phpbb.com/"
SRC_URI="http://download.phpbb.com/pub/release/${PV:0:3}/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~arm64 ~ppc ~sparc ~x86"

RDEPEND="virtual/httpd-php"

need_httpd_cgi

S=${WORKDIR}/${PN}3

src_install() {
	webapp_src_preinst

	dodoc docs/*
	rm -rf docs

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_serverowned "${MY_HTDOCSDIR}"/cache
	webapp_serverowned "${MY_HTDOCSDIR}"/files
	webapp_serverowned "${MY_HTDOCSDIR}"/images/avatars/upload
	webapp_serverowned "${MY_HTDOCSDIR}"/store
	webapp_serverowned "${MY_HTDOCSDIR}"/config.php
	webapp_configfile  "${MY_HTDOCSDIR}"/config.php

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_src_install
}
