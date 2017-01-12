# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PHP_EXT_NAME="memcached"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS=( ChangeLog README.markdown )

USE_PHP="php5-6 php7-0 php7-1"

inherit php-ext-source-r3 vcs-snapshot

USE_PHP="php7-0 php7-1"

SRC_URI="https://github.com/php-memcached-dev/php-memcached/archive/e65be324557eda7167c4831b4bfb1ad23a152beb.tar.gz -> ${P}.tar.gz"
HOMEPAGE="http://pecl.php.net/package/memcached"
KEYWORDS="~amd64 ~x86"

DESCRIPTION="Interface PHP with memcached via libmemcached library"
LICENSE="PHP-3"
SLOT="7"
IUSE="+session igbinary json sasl"

COMMON_DEPEND=">=dev-libs/libmemcached-1.0.14[sasl?]
	sys-libs/zlib
	igbinary? ( dev-php/igbinary[php_targets_php7-0?] )"

DEPEND="php_targets_php7-0? ( ${COMMON_DEPEND} dev-lang/php:7.0[session?,json?] )
	php_targets_php7-1? ( ${COMMON_DEPEND} dev-lang/php:7.1[session?,json?] )"
RDEPEND="${DEPEND} php_targets_php5-6? ( dev-php/pecl-memcached:0[php_targets_php5-6] )"

src_unpack(){
	if use php_targets_php7-0 || use php_targets_php7-1 ; then
		vcs-snapshot_src_unpack
		php-ext-source-r3_src_unpack
	else
		S="${WORKDIR}"
	fi
}

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
	if use php_targets_php7-0 || use php_targets_php7-1 ; then
		php-ext-source-r3_src_install
	fi
}
