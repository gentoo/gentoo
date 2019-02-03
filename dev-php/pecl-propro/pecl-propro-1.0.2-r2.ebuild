# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PHP_EXT_NAME="propro"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
PHP_EXT_ECONF_ARGS=""
PHP_INI_NAME="30-propro"

USE_PHP="php5-6 php7-0 php7-1 php7-2"

inherit php-ext-pecl-r3

USE_PHP="php5-6"

KEYWORDS="~amd64 ~x86"

DESCRIPTION="A reusable, property proxy API for PHP"
LICENSE="BSD-2"
SLOT="0"
IUSE=""

PDEPEND="
	php_targets_php7-0? ( dev-php/pecl-propro:7[php_targets_php7-0] )
	php_targets_php7-1? ( dev-php/pecl-propro:7[php_targets_php7-1] )
	php_targets_php7-2? ( dev-php/pecl-propro:7[php_targets_php7-2] )"

src_prepare() {
	if use php_targets_php5-6 ; then
		php-ext-source-r3_src_prepare
	else
		default_src_prepare
	fi
}

src_install() {
	if use php_targets_php5-6 ; then
		php-ext-pecl-r3_src_install
	fi
}
