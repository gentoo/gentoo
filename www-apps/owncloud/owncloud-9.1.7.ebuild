# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils webapp

DESCRIPTION="Web-based storage application where all your data is under your own control"
HOMEPAGE="http://owncloud.org"
SRC_URI="http://download.owncloud.org/community/${P}.tar.bz2 -> ${PF}.tar.bz2"
LICENSE="AGPL-3"

KEYWORDS="~amd64 ~arm ~x86"
IUSE="+curl mysql postgres +sqlite"
REQUIRED_USE="|| ( mysql postgres sqlite )"

DEPEND=""
RDEPEND="<dev-lang/php-7.1[curl?,filter,gd,hash,json,mysql?,pdo,posix,postgres?,session,simplexml,sqlite?,xmlreader,xmlwriter,zip]
	<virtual/httpd-php-7.1"

S=${WORKDIR}/${PN}

pkg_setup() {
	webapp_pkg_setup
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

pkg_postinst() {
	elog "Additional applications (calendar, ...) are no longer provided by default."
	elog "You can install them after login via the applications management page"
	elog "(check the recommended tab). No application data is lost."
	webapp_pkg_postinst
}
