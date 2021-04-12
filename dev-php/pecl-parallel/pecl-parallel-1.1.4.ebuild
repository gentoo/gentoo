# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PHP_EXT_NAME="parallel"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php7-3 php7-4"

inherit php-ext-pecl-r3

SRC_URI="${SRC_URI} -> ${P}.tgz"

KEYWORDS="~amd64 ~x86"

DESCRIPTION="A succint parallel concurrency API for PHP"
LICENSE="PHP-3.01"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	php_targets_php7-3? ( dev-lang/php:7.3[threads] )
	php_targets_php7-4? ( dev-lang/php:7.4[threads] )
"
DEPEND="test? ( ${RDEPEND} )"
