# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
