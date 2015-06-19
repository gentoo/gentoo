# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/pecl-taint/pecl-taint-1.2.2-r1.ebuild,v 1.1 2014/09/30 23:45:58 grknight Exp $

EAPI=5

# Fails to build with php5-5 and php5-6
USE_PHP="php5-4"

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
