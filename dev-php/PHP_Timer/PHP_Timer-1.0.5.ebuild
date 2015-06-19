# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PHP_Timer/PHP_Timer-1.0.5.ebuild,v 1.4 2015/02/25 15:40:46 ago Exp $

EAPI=5

PHP_PEAR_CHANNEL="${FILESDIR}/channel.xml"
PHP_PEAR_URI="pear.phpunit.de"
PHP_PEAR_PN="PHP_Timer"

inherit php-pear-lib-r1

DESCRIPTION="Utility class for timing"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 hppa x86"
IUSE=""
HOMEPAGE="http://pear.phpunit.de/"
