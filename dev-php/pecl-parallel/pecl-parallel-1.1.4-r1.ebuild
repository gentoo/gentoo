# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PHP_EXT_NAME="parallel"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
PHP_EXT_NEEDED_USE="threads"

USE_PHP="php7-4"
SLOT="7"

inherit php-ext-pecl-r3

SRC_URI="${SRC_URI} -> ${P}.tgz"

KEYWORDS="~amd64 ~x86"

DESCRIPTION="A succint parallel concurrency API for PHP"
LICENSE="PHP-3.01"
