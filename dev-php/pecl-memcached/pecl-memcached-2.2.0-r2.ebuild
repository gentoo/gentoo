# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PHP_EXT_NAME="memcached"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS=( ChangeLog README.markdown )

USE_PHP="php5-6 php7-0"

inherit php-ext-pecl-r3

USE_PHP="php5-6"

KEYWORDS="amd64 x86"

DESCRIPTION="Interface PHP with memcached via libmemcached library"
LICENSE="PHP-3"
SLOT="0"
IUSE="+session igbinary json sasl"

DEPEND="php_targets_php5-6? (
		>=dev-libs/libmemcached-1.0[sasl?]
		sys-libs/zlib
		dev-lang/php:5.6[session?,json?]
		igbinary? ( dev-php/igbinary[php_targets_php5-6?] )
	)"
RDEPEND="${DEPEND}"
PDEPEND="php_targets_php7-0? ( dev-php/pecl-memcached:7[php_targets_php7-0] )"

src_prepare(){
	if use php_targets_php5-6 ; then
		php-ext-source-r3_src_prepare
	else
		default_src_prepare
	fi
}

src_configure() {
	local PHP_EXT_ECONF_ARGS="--enable-memcached
		$(use_enable session memcached-session)
		$(use_enable sasl memcached-sasl)
		$(use_enable json memcached-json)
		$(use_enable igbinary memcached-igbinary)"

	php-ext-source-r3_src_configure
}

src_install() {
	if use php_targets_php5-6 ; then
		php-ext-pecl-r3_src_install
	fi
}
