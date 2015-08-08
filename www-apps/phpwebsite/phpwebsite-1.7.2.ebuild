# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit webapp

MY_PV=${PV//./_}
DESCRIPTION="phpWebSite Content Management System"
HOMEPAGE="http://phpwebsite.appstate.edu"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${MY_PV}.tar.gz"

LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ppc ~ppc64 x86"
IUSE="+mysql postgres"
REQUIRED_USE="|| ( mysql postgres )"

S="${WORKDIR}"/${PN}_${MY_PV}

RDEPEND="virtual/httpd-php
	dev-lang/php[gd,mysql?,postgres?]"

src_install() {
	webapp_src_preinst

	dodoc README docs/*

	cp -r * "${D}/${MY_HTDOCSDIR}"

	# Files that need to be owned by webserver
	webapp_serverowned ${MY_HTDOCSDIR}/config
	webapp_serverowned ${MY_HTDOCSDIR}/config/core
	webapp_serverowned ${MY_HTDOCSDIR}/files
	webapp_serverowned ${MY_HTDOCSDIR}/images
	webapp_serverowned ${MY_HTDOCSDIR}/mod
	webapp_serverowned ${MY_HTDOCSDIR}/logs
	webapp_serverowned ${MY_HTDOCSDIR}/templates
	webapp_serverowned ${MY_HTDOCSDIR}/javascript

#	webapp_postinst_txt en ${FILESDIR}/postinstall-en.txt

	webapp_src_install
}
