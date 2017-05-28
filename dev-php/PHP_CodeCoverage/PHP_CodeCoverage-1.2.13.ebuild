# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PHP_PEAR_DOMAIN="pear.phpunit.de"
PHP_PEAR_CHANNEL="${FILESDIR}/channel.xml"

inherit php-pear-r2

DESCRIPTION="Collection, processing, and rendering for PHP code coverage"
HOMEPAGE="http://pear.phpunit.de"
SRC_URI="http://${PHP_PEAR_URI}/get/${PEAR_P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 hppa x86"
IUSE=""

DEPEND=">=dev-php/pear-1.9.4"
RDEPEND="${DEPEND}
	>=dev-php/File_Iterator-1.3.0
	>=dev-php/PHP_TokenStream-1.1.3
	>=dev-php/Text_Template-1.1.1"
