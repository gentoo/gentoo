# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

USE_PHP="php7-1 php7-2 php7-3"
inherit php-ext-pecl-r3

DESCRIPTION="Extension used for detecting XSS code (tainted strings)"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

pkg_postinst() {
	elog 'To enable this extension, add'
	elog '  taint.enable=1'
	elog 'to /etc/php/<sapi>-<slot>/ext/taint.ini'
}
