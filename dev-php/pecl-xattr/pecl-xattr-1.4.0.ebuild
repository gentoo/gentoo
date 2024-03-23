# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PHP_EXT_INI="yes"
PHP_EXT_NAME="xattr"
PHP_EXT_NEEDED_USE=""
PHP_EXT_ZENDEXT="no"
USE_PHP="php8-1 php8-2"

inherit php-ext-pecl-r3

DESCRIPTION="Extended attributes for PHP"
SRC_URI="${SRC_URI} -> ${P}.tgz"

LICENSE="PHP-3.01"
SLOT="8"
KEYWORDS="~amd64 ~x86"
