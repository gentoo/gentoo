# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit webapp

MY_P="${PN}-com-${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Group-Office is a powerful modular Intranet application framework"
HOMEPAGE="http://group-office.sourceforge.net/"
SRC_URI="mirror://sourceforge/group-office/${MY_P}.tar.gz"

LICENSE="AGPL-3"
KEYWORDS="amd64 ~hppa ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="app-arch/zip
		 app-arch/unzip
		 virtual/httpd-cgi
		 dev-lang/php[calendar,cli,curl,gd,imap,mysqli,zlib]"

src_install() {
	webapp_src_preinst

	local docs="CHANGELOG.TXT FAQ.TXT INSTALL.TXT"

	dodoc ${docs} RELEASE.TXT LICENSE.TXT

	cp -r . "${D}${MY_HTDOCSDIR}"
	for doc in ${docs}; do
		rm -f "${D}${MY_HTDOCSDIR}/${doc}"
	done

	touch "${D}${MY_HTDOCSDIR}"/config.php
	dodir "${MY_HOSTROOTDIR}/${P}"/userdata "${MY_HTDOCSDIR}"/local

	webapp_serverowned "${MY_HTDOCSDIR}"
	webapp_serverowned -R "${MY_HOSTROOTDIR}/${P}"/userdata
	webapp_serverowned "${MY_HTDOCSDIR}"/local
	webapp_serverowned "${MY_HTDOCSDIR}"/config.php
	webapp_configfile "${MY_HTDOCSDIR}"/config.php

	webapp_postinst_txt en "${FILESDIR}"/postinstall2-en.txt
	webapp_src_install
}
