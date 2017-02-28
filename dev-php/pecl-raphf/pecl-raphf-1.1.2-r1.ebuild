# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PHP_EXT_NAME="raphf"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
PHP_EXT_ECONF_ARGS=""

USE_PHP="php5-6 php7-0 php7-1"

inherit php-ext-pecl-r3

USE_PHP="php5-6"

KEYWORDS="amd64 x86"

DESCRIPTION="A reusable, persistent handle and resource factory API"
LICENSE="BSD-2"
SLOT="0"
IUSE=""

PDEPEND="
	php_targets_php7-0? ( dev-php/pecl-raphf:7[php_targets_php7-0] )
	php_targets_php7-1? ( dev-php/pecl-raphf:7[php_targets_php7-1] )"

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
