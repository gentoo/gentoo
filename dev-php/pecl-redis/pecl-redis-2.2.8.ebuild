# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PHP_EXT_NAME="redis"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php5-6 php7-0"

DOCS=( arrays.markdown README.markdown )

inherit php-ext-pecl-r3

USE_PHP="php5-6"

KEYWORDS="~amd64"

DESCRIPTION="PHP extension for interfacing with Redis"
LICENSE="PHP-3.01"
SLOT="0"
IUSE="igbinary"

DEPEND="igbinary? ( php_targets_php5-6? ( dev-php/igbinary[php_targets_php5-6] ) )"
RDEPEND="${DEPEND}"
PDEPEND="php_targets_php7-0? ( dev-php/pecl-redis:7[php_targets_php7-0] )"

src_prepare() {
	if use php_targets_php5-6 ; then
		php-ext-source-r3_src_prepare
	else
		default_src_prepare
	fi
}

src_configure() {
	local PHP_EXT_ECONF_ARGS=( --enable-redis
		$(use_enable igbinary redis-igbinary) )

	php-ext-source-r3_src_configure
}

src_install() {
	if use php_targets_php5-6 ; then
		php-ext-pecl-r3_src_install
	fi
}
