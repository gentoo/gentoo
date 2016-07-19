# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PHP_EXT_NAME="mailparse"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS=( README )

USE_PHP="php7-0 php5-6"

inherit php-ext-pecl-r3

# Only build for 7.0
USE_PHP="php7-0"

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

DESCRIPTION="PHP extension for parsing and working with RFC822 and MIME compliant messages"
LICENSE="PHP-3.01"
SLOT="7"
IUSE=""

for target in ${USE_PHP}; do
	phpslot=${target/php}
	phpslot=${phpslot/-/.}
	PHPUSEDEPEND="${PHPUSEDEPEND}
	php_targets_${target}? ( dev-lang/php:${phpslot}[unicode] )"
done
unset target phpslot

DEPEND="${PHPUSEDEPEND}
	dev-util/re2c"
RDEPEND="${PHPUSEDEPEND} php_targets_php5-6? ( dev-php/pecl-mailparse:0[php_targets_php5-6] )"
