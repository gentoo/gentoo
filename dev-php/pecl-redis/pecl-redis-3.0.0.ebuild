# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PHP_EXT_NAME="redis"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php5-6 php7-0"

DOCS="arrays.markdown README.markdown"

inherit php-ext-pecl-r2

#redefine in order to only build for 7.0
USE_PHP="php7-0"

KEYWORDS="~amd64"

DESCRIPTION="PHP extension for interfacing with Redis"
LICENSE="PHP-3.01"
SLOT="7"
IUSE="igbinary"

DEPEND="igbinary? ( php_targets_php7-0? ( dev-php/igbinary[php_targets_php7-0] ) )"
RDEPEND="${DEPEND} php_targets_php5-6? ( dev-php/pecl-redis:0 )"

src_configure() {
	my_conf="--enable-redis
		$(use_enable igbinary redis-igbinary)"

	php-ext-source-r2_src_configure
}

src_install() {
	if use php_targets_php7-0 ; then
		php-ext-pecl-r2_src_install
	fi
}
