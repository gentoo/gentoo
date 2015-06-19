# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/owncloud/owncloud-7.0.6.ebuild,v 1.2 2015/06/18 12:17:08 voyageur Exp $

EAPI=5

inherit eutils webapp

DESCRIPTION="Web-based storage application where all your data is under your own control"
HOMEPAGE="http://owncloud.org"
SRC_URI="http://download.owncloud.org/community/${P}.tar.bz2 -> ${PF}.tar.bz2"
LICENSE="AGPL-3"

KEYWORDS="~amd64 ~arm ~x86"
IUSE="+curl mysql postgres +sqlite"
REQUIRED_USE="|| ( mysql postgres sqlite )"

DEPEND=""
RDEPEND="dev-lang/php[curl?,filter,gd,hash,json,mysql?,pdo,postgres?,simplexml,sqlite?,xmlwriter,zip]
	virtual/httpd-php"

S=${WORKDIR}/${PN}

pkg_setup() {
	webapp_pkg_setup
}

src_prepare() {
	epatch_user
}

src_install() {
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r .
	dodir "${MY_HTDOCSDIR}"/data

	webapp_serverowned -R "${MY_HTDOCSDIR}"/apps
	webapp_serverowned -R "${MY_HTDOCSDIR}"/data
	webapp_serverowned -R "${MY_HTDOCSDIR}"/config
	webapp_configfile "${MY_HTDOCSDIR}"/.htaccess

	webapp_src_install
}
