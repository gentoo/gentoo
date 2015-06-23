# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/eyeos/eyeos-2.5.ebuild,v 1.2 2015/06/23 09:17:43 voyageur Exp $

EAPI=5
inherit webapp eutils

DESCRIPTION="AJAX web-based desktop environment"
HOMEPAGE="http://www.eyeos.org"
SRC_URI="mirror://sourceforge/eyeos/eyeos2/${P}.tar.gz"

LICENSE="AGPL-3"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/php[curl,crypt,gd,json,mysql,mysqli,pdo,sharedmem,sqlite]
	virtual/httpd-php"

S=${WORKDIR}

src_install() {
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	# Placeholder for first install
	touch "${ED}/${MY_HTDOCSDIR}"/settings.php
	webapp_configfile "${MY_HTDOCSDIR}"/settings.php
	webapp_serverowned "${MY_HTDOCSDIR}"/settings.php

	# Ugly, but eyeos needs write access in too many places
	webapp_serverowned -R "${MY_HTDOCSDIR}"/eyeos/system
	webapp_serverowned -R "${MY_HTDOCSDIR}"/eyeos/tmp
	webapp_serverowned -R "${MY_HTDOCSDIR}"/eyeos/users

	webapp_src_install
}

pkg_postinst() {
	elog "To finish your install/upgrade, point your browser to the eyeOS installer at:"
	elog "	http://${VHOST_HOSTNAME}/${PN}/install/"
	elog "Specific extensions may require additional packages (available or not in"
	elog "portage), check the installer output"
	webapp_pkg_postinst
}
