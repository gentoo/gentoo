# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PHP_EXT_NAME="redis"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php5-4 php5-5 php5-6"

DOCS="arrays.markdown README.markdown"

inherit php-ext-pecl-r2

KEYWORDS="amd64"

DESCRIPTION="PHP extension for interfacing with Redis"
LICENSE="PHP-3.01"
SLOT="0"
IUSE="igbinary"

DEPEND="igbinary? (
	php_targets_php5-4? ( dev-php/igbinary[php_targets_php5-4] )
	php_targets_php5-5? ( dev-php/igbinary[php_targets_php5-5] )
	php_targets_php5-6? ( dev-php/igbinary[php_targets_php5-6] ) )"
RDEPEND="${DEPEND}"

src_configure() {
	my_conf="--enable-redis
		$(use_enable igbinary redis-igbinary)"

	php-ext-source-r2_src_configure
}
