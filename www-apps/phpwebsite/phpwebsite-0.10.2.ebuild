# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit webapp

DESCRIPTION="phpWebSite Content Management System"
HOMEPAGE="http://phpwebsite.appstate.edu"
SRC_URI="mirror://sourceforge/${PN}/${P}-full.tar.gz
http://phpwebsite.appstate.edu/downloads/security/phpws_patch_20060419.2.tgz"

LICENSE="LGPL-2.1"
KEYWORDS="ppc x86"
IUSE=""

RDEPEND="virtual/httpd-php"

S=${WORKDIR}

src_unpack() {
	unpack ${A} && cd ${S}
	cp -f index.php ${P}-full
}

src_install() {
	webapp_src_preinst

	cd ${S}/${P}-full

	local docs="docs/CHANGELOG.txt docs/CONVERSION.txt docs/CREDITS.txt docs/INSTALL.txt docs/KNOWNISSUES.txt docs/PEARERRORS.txt docs/README.txt docs/REQUIREMENTS.txt docs/THEMES.txt docs/UNINSTALL.txt docs/UPGRADE.txt docs/sample.config.php"
	dodoc ${docs}

	einfo "Installing main files"
	cp -r * ${D}${MY_HTDOCSDIR}

	#webapp_configfile ${MY_HTDOCSDIR}/conf/config.php

	# Files that need to be owned by webserver
	webapp_serverowned ${MY_HTDOCSDIR}/conf
	webapp_serverowned ${MY_HTDOCSDIR}/files
	webapp_serverowned ${MY_HTDOCSDIR}/images
	webapp_serverowned ${MY_HTDOCSDIR}/images/mod
	webapp_serverowned ${MY_HTDOCSDIR}/images/mod/controlpanel
	webapp_serverowned ${MY_HTDOCSDIR}/mod

	webapp_postinst_txt en ${FILESDIR}/postinstall-en.txt

	webapp_src_install
}
