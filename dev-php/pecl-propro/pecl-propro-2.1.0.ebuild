# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PHP_EXT_NAME="propro"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
PHP_EXT_ECONF_ARGS=""
PHP_INI_NAME="30-${PHP_EXT_NAME}"

USE_PHP="php7-3 php7-4"

inherit php-ext-pecl-r3

KEYWORDS="amd64 x86"

DESCRIPTION="A reusable property proxy API for PHP"
LICENSE="BSD-2"
SLOT="7"
IUSE=""
