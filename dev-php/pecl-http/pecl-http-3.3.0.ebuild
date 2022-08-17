# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PHP_EXT_NAME="http"
PHP_EXT_PECL_PKG="pecl_http"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
PHP_INI_NAME="50-http"

USE_PHP="php7-4 php8-0 php8-1"

inherit php-ext-pecl-r3

USE_PHP="php7-4"

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Extended HTTP Support for PHP"
LICENSE="BSD-2 MIT"
SLOT="7"
IUSE="ssl curl_ssl_gnutls curl_ssl_nss +curl_ssl_openssl"

# Patch gets cookies working with curl 7.77, but further interop work was done later
# Just set min version for this short time to live branch
COMMON_DEPEND="app-arch/brotli:=
	dev-libs/libevent
	dev-php/pecl-propro:7[php_targets_php7-4(-)?]
	>=dev-php/pecl-raphf-2.0.1:7[php_targets_php7-4(-)?]
	net-dns/libidn2
	sys-libs/zlib
	ssl? ( >=net-misc/curl-7.77[ssl,curl_ssl_gnutls(-)=,curl_ssl_nss(-)=,curl_ssl_openssl(-)=] )
	!ssl? ( >=net-misc/curl-7.77[-ssl] )
"
DEPEND="php_targets_php7-4? ( ${COMMON_DEPEND} dev-lang/php:7.4[session(-),iconv(-)] )"
RDEPEND="${DEPEND}
	php_targets_php8-0? ( dev-php/pecl-http:8[php_targets_php8-0(-)] )
	php_targets_php8-1? ( dev-php/pecl-http:8[php_targets_php8-1(-)] )"

PHP_EXT_ECONF_ARGS=( --with-http --without-http-shared-deps
	--without-http-libidn-dir --without-http-libicu-dir
	--without-http-libidnkit2-dir --without-http-libidnkit-dir )

src_prepare() {
	if use php_targets_php7-4 ; then
		php-ext-source-r3_src_prepare
	else
		default_src_prepare
	fi
}

src_install() {
	if use php_targets_php7-4 ; then
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
		SKIP_ONLINE_TESTS=yes NO_INTERACTION="yes" emake test
		# Clean up testing links
		rm modules/propro.so modules/raphf.so || die
	done
}
