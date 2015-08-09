# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_PHP="php5-5 php5-4"

inherit php-ext-pecl-r2

DESCRIPTION="An extension to track progress of a file upload"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/php[apache2]"

pkg_postinst() {
	elog "This extension is only known to work on Apache with mod_php."
}
