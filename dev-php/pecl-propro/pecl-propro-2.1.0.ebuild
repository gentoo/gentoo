# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PHP_EXT_NAME="propro"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
PHP_EXT_ECONF_ARGS=""
PHP_INI_NAME="30-${PHP_EXT_NAME}"

USE_PHP="php5-6 php7-1 php7-2 php7-3 php7-4"

inherit php-ext-pecl-r3

# Only really build for 7.x
USE_PHP="php7-1 php7-2 php7-3 php7-4"

KEYWORDS="amd64 x86"

DESCRIPTION="A reusable property proxy API for PHP"
LICENSE="BSD-2"
SLOT="7"
IUSE=""

RDEPEND="php_targets_php5-6? ( ${CATEGORY}/${PN}:0[php_targets_php5-6] )"

src_prepare() {
	if use php_targets_php7-1 || use php_targets_php7-2 || use php_targets_php7-3 || use php_targets_php7-4 ; then
		php-ext-source-r3_src_prepare
	else
		default_src_prepare
	fi
}

src_install() {
	if use php_targets_php7-1 || use php_targets_php7-2 || use php_targets_php7-3 || use php_targets_php7-4 ; then
		php-ext-pecl-r3_src_install
	fi
}
