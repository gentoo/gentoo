# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PHP_EXT_NAME="http"
PHP_EXT_PECL_PKG="pecl_http"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php5-6 php7-0 php7-1"

inherit php-ext-pecl-r3

USE_PHP="php7-0 php7-1"

KEYWORDS="amd64 x86"

DESCRIPTION="Extended HTTP Support for PHP"
LICENSE="BSD-2 MIT"
SLOT="7"
IUSE="ssl curl_ssl_gnutls curl_ssl_libressl curl_ssl_nss +curl_ssl_openssl"

DEPEND="dev-libs/libevent
	dev-php/pecl-propro:7[php_targets_php5-6?,php_targets_php7-0?,php_targets_php7-1?]
	dev-php/pecl-raphf:7[php_targets_php5-6?,php_targets_php7-0?,php_targets_php7-1?]
	net-dns/libidn
	sys-libs/zlib
	ssl? ( net-misc/curl[ssl,curl_ssl_gnutls=,curl_ssl_libressl=,curl_ssl_nss=,curl_ssl_openssl=] )
	!ssl? ( net-misc/curl[-ssl] )
	php_targets_php7-0? ( dev-lang/php:7.0[hash,session,iconv] )
	php_targets_php7-1? ( dev-lang/php:7.1[hash,session,iconv] )"
RDEPEND="${DEPEND}
	php_targets_php5-6? ( dev-php/pecl-http:2[php_targets_php5-6] )"

PHP_EXT_ECONF_ARGS=( --with-http --without-http-shared-deps --without-http-libidn2-dir )

PATCHES=( "${FILESDIR}/pecl-http-gnutls.patch" )

src_prepare() {
	if use php_targets_php7-0 || use php_targets_php7-1 ; then
		php-ext-source-r3_src_prepare
	else
		default_src_prepare
	fi
}

src_install() {
	if use php_targets_php7-0 || use php_targets_php7-1 ; then
		php-ext-pecl-r3_src_install
	fi
}

pkg_postinst() {
	ewarn "This API has drastically changed and is not compatible with the 1.x syntax."
	ewarn "Please review the documentation and update your code."
}
