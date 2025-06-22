# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PHP_EXT_INI="yes"
PHP_EXT_NAME="parallel"
PHP_EXT_NEEDED_USE="threads"
PHP_EXT_ZENDEXT="no"
USE_PHP="php8-2 php8-3"

inherit php-ext-pecl-r3

DESCRIPTION="A succint parallel concurrency API for PHP"
SRC_URI="${SRC_URI} -> ${P}.tgz"

PATCHES="${FILESDIR}/pecl-parallel-1.2.6-php8.3.patch"

LICENSE="PHP-3.01"
SLOT="8"
KEYWORDS="amd64 x86"
