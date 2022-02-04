# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PHP_PEAR_CHANNEL="${FILESDIR}/channel.xml"
PHP_PEAR_DOMAIN="pear.phpunit.de"
PHP_PEAR_PKG_NAME="Text_Template"

inherit php-pear-r2

HOMEPAGE="http://pear.phpunit.de"
SRC_URI="http://${PHP_PEAR_URI}/get/${PEAR_P}.tgz"
DESCRIPTION="Simple template engine"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~hppa x86"
IUSE=""

DEPEND=">=dev-php/pear-1.9.4"
DOCS=( README.markdown ChangeLog.markdown )
