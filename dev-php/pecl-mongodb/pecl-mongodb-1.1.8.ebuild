# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PHP_EXT_NAME="mongodb"
USE_PHP="php5-6 php7-0"
DOCS=( README.md )

inherit php-ext-pecl-r3

DESCRIPTION="MongoDB database driver for PHP"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl pcre sasl"

RDEPEND="
	php_targets_php5-6? ( dev-lang/php:5.6[json,ssl,zlib] )
	php_targets_php7-0? ( dev-lang/php:7.0[json,ssl,zlib] )
	>=dev-libs/libbson-1.3.3
	>=dev-libs/mongo-c-driver-1.3.3[sasl?,ssl]
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	pcre? ( dev-libs/libpcre )
	sasl? ( dev-libs/cyrus-sasl )
"
# pkgconfig needed if system libraries are used for bson and libmongoc
DEPEND="${RDEPEND} virtual/pkgconfig"

src_configure() {
	local PHP_EXT_ECONF_ARGS=( --enable-mongodb --with-libbson --with-libmongoc )
	PHP_EXT_ECONF_ARGS+=( --with-pcre-dir=$(usex pcre yes no) --with-mongodb-sasl=$(usex sasl yes no) )
	php-ext-source-r3_src_configure
}
