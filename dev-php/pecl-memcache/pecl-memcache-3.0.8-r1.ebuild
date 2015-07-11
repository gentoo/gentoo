# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/pecl-memcache/pecl-memcache-3.0.8-r1.ebuild,v 1.6 2015/07/11 11:54:20 jer Exp $

EAPI="5"
PHP_EXT_NAME="memcache"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="README"

USE_PHP="php5-6 php5-5 php5-4"

inherit php-ext-pecl-r2

KEYWORDS="amd64 hppa ppc64 x86"

DESCRIPTION="PHP extension for using memcached"
LICENSE="PHP-3"
SLOT="0"
IUSE="+session"

DEPEND="sys-libs/zlib
		dev-lang/php:*[session?]"
RDEPEND="${DEPEND}"

# The test suite requires memcached to be running.
RESTRICT='test'

src_configure() {
	my_conf="--enable-memcache --with-zlib-dir=/usr $(use_enable session memcache-session)"
	php-ext-source-r2_src_configure
}

src_install() {
	php-ext-pecl-r2_src_install

	php-ext-source-r2_addtoinifiles "memcache.allow_failover" "true"
	php-ext-source-r2_addtoinifiles "memcache.max_failover_attempts" "20"
	php-ext-source-r2_addtoinifiles "memcache.chunk_size" "32768"
	php-ext-source-r2_addtoinifiles "memcache.default_port" "11211"
	php-ext-source-r2_addtoinifiles "memcache.hash_strategy" "consistent"
	php-ext-source-r2_addtoinifiles "memcache.hash_function" "crc32"
	php-ext-source-r2_addtoinifiles "memcache.redundancy" "1"
	php-ext-source-r2_addtoinifiles "memcache.session_redundancy" "2"
	php-ext-source-r2_addtoinifiles "memcache.protocol" "ascii"
}
