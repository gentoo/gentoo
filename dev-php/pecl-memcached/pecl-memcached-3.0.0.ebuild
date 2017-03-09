# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PHP_EXT_NAME="memcached"
PHP_EXT_PECL_PKG="php-memcached" # Needed when SRC_URI is Github.
DOCS=( ChangeLog README.markdown )

USE_PHP="php5-6 php7-0 php7-1" # Pretend to support all three targets...
inherit php-ext-pecl-r3
USE_PHP="php7-0 php7-1" # But only truly build for these two.

DESCRIPTION="Interface PHP with memcached via libmemcached library"
# Usually set in the eclass, but this release made it to github first.
SRC_URI="https://github.com/php-memcached-dev/php-memcached/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="PHP-3"
SLOT="7"
KEYWORDS="amd64 x86"
IUSE="examples igbinary json sasl +session "

COMMON_DEPEND=">=dev-libs/libmemcached-1.0.14[sasl?]
	sys-libs/zlib
	igbinary? ( dev-php/igbinary[php_targets_php7-0?] )"

DEPEND="
	php_targets_php7-0? (
		${COMMON_DEPEND} dev-lang/php:7.0[session?,json?]
	)
	php_targets_php7-1? (
		${COMMON_DEPEND} dev-lang/php:7.1[session?,json?]
	)"
RDEPEND="${DEPEND}
	php_targets_php5-6? (
		dev-php/pecl-memcached:0[php_targets_php5-6]
	)"

src_prepare(){
	if use php_targets_php7-0 || use php_targets_php7-1 ; then
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
	use examples && dodoc -r server-example

	if use php_targets_php7-0 || use php_targets_php7-1 ; then
		php-ext-source-r3_src_install
	fi
}
