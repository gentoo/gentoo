# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

PHP_EXT_NAME="http"
PHP_EXT_PECL_PKG="pecl_http"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php5-6"

inherit php-ext-pecl-r3

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Extended HTTP Support for PHP"
LICENSE="BSD-2 MIT"
SLOT="2"
IUSE="ssl curl_ssl_gnutls curl_ssl_libressl curl_ssl_nss +curl_ssl_openssl"

DEPEND="dev-libs/libevent
	dev-php/pecl-propro:0
	dev-php/pecl-raphf:0
	net-dns/libidn
	sys-libs/zlib
	ssl? ( net-misc/curl[ssl,curl_ssl_gnutls=,curl_ssl_libressl=,curl_ssl_nss=,curl_ssl_openssl=] )
	!ssl? ( net-misc/curl[-ssl] )
	php_targets_php5-6? ( dev-lang/php:5.6[hash,session,iconv] )"
RDEPEND="${DEPEND}"

PHP_EXT_ECONF_ARGS=( --with-http --without-http-shared-deps )

pkg_postinst() {
	ewarn "This API has drastically changed and is not compatible with the 1.x syntax."
	ewarn "Please review the documentation and update your code."
}
