# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PHP_PEAR_CHANNEL="${FILESDIR}/channel.xml"
PHP_PEAR_DOMAIN="pear.phpunit.de"
PHP_PEAR_PKG_NAME="PHP_Timer"

inherit php-pear-r2

DESCRIPTION="Utility class for timing"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~hppa x86"
IUSE=""
HOMEPAGE="http://pear.phpunit.de/"
SRC_URI="http://${PHP_PEAR_URI}/get/${PEAR_P}.tgz"
