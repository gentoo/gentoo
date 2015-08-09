# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit php-pear-r1

DESCRIPTION="Web-application and persistance framework based on Ruby on Rails"
HOMEPAGE="http://www.phpontrax.com/"
SRC_URI="http://pear.phpontrax.com/get/${P}.tgz"

LICENSE="MIT"
SLOT="0"
IUSE="+mysql postgres"

KEYWORDS="~amd64 ~x86"

REQUIRED_USE="|| ( mysql postgres )"

RDEPEND="virtual/httpd-php:*
	dev-lang/php:*[session,imap]
	dev-php/PEAR-MDB2
	dev-php/PEAR-Mail
	dev-php/PEAR-Mail_Mime
	mysql? ( dev-php/PEAR-MDB2_Driver_mysql )
	postgres? ( dev-php/PEAR-MDB2_Driver_pgsql )"

pkg_postinst() {
	ewarn "This packages requires that you enable mod_rewrite in apache-2."
}
