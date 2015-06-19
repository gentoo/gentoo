# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/refbase/refbase-0.9.5.ebuild,v 1.2 2010/04/30 20:52:51 mabi Exp $

EAPI="2"
inherit depend.apache depend.php webapp

DESCRIPTION="Web-based solution for managing scientific literature, references and citations"
HOMEPAGE="http://www.refbase.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
IUSE=""
DEPEND="|| ( <dev-lang/php-5.3[pcre] >=dev-lang/php-5.3 )
	dev-lang/php[mysql,session]
	app-admin/webapp-config
	app-text/bibutils"
RDEPEND="${DEPEND}"

need_apache
need_php

pkg_setup() {
	webapp_pkg_setup
}

src_install () {
	webapp_src_preinst

	DOCS="AUTHORS BUGS ChangeLog NEWS README TODO UPDATE"
	dodoc ${DOCS}
	# Don't install docs to webroot
	rm -f ${DOCS} COPYING INSTALL

	cp -R * "${D}"${MY_HTDOCSDIR}

	webapp_configfile ${MY_HTDOCSDIR}/initialize
	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt

	webapp_src_install
}
