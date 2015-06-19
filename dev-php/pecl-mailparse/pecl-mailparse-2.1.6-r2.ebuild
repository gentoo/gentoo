# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/pecl-mailparse/pecl-mailparse-2.1.6-r2.ebuild,v 1.1 2015/04/29 01:29:36 grknight Exp $

EAPI=5

PHP_EXT_NAME="mailparse"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="README"

USE_PHP="php5-5 php5-4"

inherit php-ext-pecl-r2

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

DESCRIPTION="A PHP extension for parsing and working with RFC822 and RFC2045 (MIME) compliant messages"
LICENSE="PHP-2.02"
SLOT="0"
IUSE=""

for target in ${USE_PHP}; do
	slot=${target/php}
	slot=${slot/-/.}
	PHPUSEDEPEND="${PHPUSEDEPEND}
	php_targets_${target}? ( dev-lang/php:${slot}[unicode] )"
done

RDEPEND="${PHPUSEDEPEND}"
DEPEND="${RDEPEND}
	dev-util/re2c"
