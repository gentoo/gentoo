# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_PHP="php7-0"
MY_PV="${PV/_beta/}"
inherit php-ext-pecl-r2

DESCRIPTION="Extension used for detecting XSS codes(tainted string)"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

pkg_postinst() {
	elog 'In order to enable this extension, add'
	elog '  taint.enable=1'
	elog 'to /etc/php/<sapi>-<slot>/ext/taint.ini'
}
