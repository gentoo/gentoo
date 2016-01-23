# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PHP_EXT_NAME="memcached"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="ChangeLog README.markdown"

USE_PHP="php5-4 php5-5 php5-6"

inherit php-ext-pecl-r2

KEYWORDS="amd64 ~x86"

DESCRIPTION="Interface PHP with memcached via libmemcached library"
LICENSE="PHP-3"
SLOT="0"
IUSE="+session igbinary json sasl"

DEPEND="|| ( >=dev-libs/libmemcached-1.0.14 >=dev-libs/libmemcached-1.0[sasl?] )
		sys-libs/zlib
		dev-lang/php:*[session?,json?]
		igbinary? ( dev-php/igbinary[php_targets_php5-4?,php_targets_php5-5?,php_targets_php5-6?] )"
RDEPEND="${DEPEND}"

src_configure() {
	my_conf="--enable-memcached
		$(use_enable session memcached-session)
		$(use_enable sasl memcached-sasl)
		$(use_enable json memcached-json)
		$(use_enable igbinary memcached-igbinary)"

	php-ext-source-r2_src_configure
}
