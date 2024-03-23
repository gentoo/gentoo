# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PHP_EXT_NAME="dio"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php8-1 php8-2 php8-3"

inherit php-ext-pecl-r3

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Direct I/O functions for PHP"
LICENSE="PHP-3.01"
SLOT="0"
