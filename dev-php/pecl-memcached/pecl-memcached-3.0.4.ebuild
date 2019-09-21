# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PHP_EXT_NAME="memcached"
DOCS=( ChangeLog README.markdown )

USE_PHP="php5-6 php7-0 php7-1 php7-2" # Pretend to support all three targets...
inherit php-ext-pecl-r3
USE_PHP="php7-0 php7-1 php7-2" # But only truly build for these two.

DESCRIPTION="Interface PHP with memcached via libmemcached library"
LICENSE="PHP-3"
SLOT="7"
KEYWORDS="amd64 x86"
IUSE="examples igbinary json sasl +session "

COMMON_DEPEND=">=dev-libs/libmemcached-1.0.14[sasl?]
	sys-libs/zlib
	igbinary? ( dev-php/igbinary[php_targets_php7-0?,php_targets_php7-1?,php_targets_php7-2?] )
"

DEPEND="
	php_targets_php7-0? (
		${COMMON_DEPEND} dev-lang/php:7.0[session?,json?]
	)
	php_targets_php7-1? (
		${COMMON_DEPEND} dev-lang/php:7.1[session?,json?]
	)
	php_targets_php7-2? (
		${COMMON_DEPEND} dev-lang/php:7.2[session?,json?]
	)"
RDEPEND="${DEPEND}
	php_targets_php5-6? (
		dev-php/pecl-memcached:0[php_targets_php5-6]
	)"

src_prepare(){
	if use php_targets_php7-0 || use php_targets_php7-1 || use php_targets_php7-2 ; then
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

src_install(){
	if use php_targets_php7-0 || use php_targets_php7-1 || use php_targets_php7-2 ; then
		php-ext-source-r3_src_install
	fi
}
