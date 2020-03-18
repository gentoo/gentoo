# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PHP_EXT_NAME="http"
PHP_EXT_PECL_PKG="pecl_http"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
PHP_INI_NAME="50-http"

USE_PHP="php5-6 php7-1 php7-2 php7-3"

inherit php-ext-pecl-r3

USE_PHP="php7-1 php7-2 php7-3"

KEYWORDS="amd64 x86"

DESCRIPTION="Extended HTTP Support for PHP"
LICENSE="BSD-2 MIT"
SLOT="7"
IUSE="ssl curl_ssl_gnutls curl_ssl_libressl curl_ssl_nss +curl_ssl_openssl"

DEPEND="app-arch/brotli:=
	dev-libs/libevent
	dev-php/pecl-propro:7[php_targets_php7-1?,php_targets_php7-2?,php_targets_php7-3?]
	dev-php/pecl-raphf:7[php_targets_php7-1?,php_targets_php7-2?,php_targets_php7-3?]
	net-dns/libidn2
	sys-libs/zlib
	ssl? ( net-misc/curl[ssl,curl_ssl_gnutls=,curl_ssl_libressl=,curl_ssl_nss=,curl_ssl_openssl=] )
	!ssl? ( net-misc/curl[-ssl] )
	php_targets_php7-1? ( dev-lang/php:7.1[hash,session,iconv] )
	php_targets_php7-2? ( dev-lang/php:7.2[hash,session,iconv] )
	php_targets_php7-3? ( dev-lang/php:7.3[hash,session,iconv] )"
RDEPEND="${DEPEND}
	php_targets_php5-6? ( dev-php/pecl-http:2[php_targets_php5-6] )"

PHP_EXT_ECONF_ARGS=( --with-http --without-http-shared-deps --without-http-libidn-dir )

src_prepare() {
	if use php_targets_php7-1 || use php_targets_php7-2 || use php_targets_php7-3 ; then
		php-ext-source-r3_src_prepare
	else
		default_src_prepare
	fi
}

src_install() {
	if use php_targets_php7-1 || use php_targets_php7-2 || use php_targets_php7-3 ; then
		php-ext-pecl-r3_src_install
	fi
}

src_test() {
	# Cannot use eclass function due to required modules
	# All tests SKIP otherwise
	for slot in $(php_get_slots); do
		php_init_slot_env "${slot}"
		# Link in required modules for testing
		ln -s "${EXT_DIR}/propro.so" "modules/propro.so" || die
		ln -s "${EXT_DIR}/raphf.so" "modules/raphf.so" || die
		sed -i \
			's/PHP_TEST_SHARED_EXTENSIONS)/PHP_TEST_SHARED_EXTENSIONS) -d extension=propro.so -d extension=raphf.so/' \
			Makefile || die
		SKIP_ONLINE_TESTS="yes" NO_INTERACTION="yes" emake test
		# Clean up testing links
		rm modules/propro.so modules/raphf.so || die
	done
}

pkg_postinst() {
	ewarn "This API has drastically changed and is not compatible with the 1.x syntax."
	ewarn "Please review the documentation and update your code."
}
