# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PHP_EXT_NAME="http"
PHP_EXT_PECL_PKG="pecl_http"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php5-6 php7-0 php7-1"

inherit php-ext-pecl-r3

USE_PHP="php5-6"

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Extended HTTP Support for PHP"
LICENSE="BSD-2 MIT"
SLOT="2"
IUSE="ssl curl_ssl_gnutls curl_ssl_libressl curl_ssl_nss +curl_ssl_openssl"

DEPEND="php_targets_php5-6? (
	dev-libs/libevent
	dev-php/pecl-propro:0[php_targets_php5-6]
	dev-php/pecl-raphf:0[php_targets_php5-6]
	net-dns/libidn
	sys-libs/zlib
	ssl? ( net-misc/curl[ssl,curl_ssl_gnutls=,curl_ssl_libressl=,curl_ssl_nss=,curl_ssl_openssl=] )
	!ssl? ( net-misc/curl[-ssl] )
	dev-lang/php:5.6[hash,session,iconv] )"
RDEPEND="${DEPEND}"
PDEPEND="
	php_targets_php7-0? ( dev-php/pecl-http:7[php_targets_php7-0] )
	php_targets_php7-1? ( dev-php/pecl-http:7[php_targets_php7-1] )"

PHP_EXT_ECONF_ARGS=( --with-http --without-http-shared-deps )

src_prepare() {
	if use php_targets_php5-6 ; then
		php-ext-source-r3_src_prepare
	else
		default_src_prepare
	fi
}

src_install() {
	if use php_targets_php5-6 ; then
		php-ext-pecl-r3_src_install

		# Ensure that the http extension is loaded after its
		# dependencies raphf and propro (bug 612054). Some day
		# this should be possible through the eclass (bug 586446).
		local slot, file, oldname, newname
		for slot in $(php_get_slots); do
			php_init_slot_env "${slot}"
			for file in $(php_slot_ini_files "${slot}") ; do
				# Prepend "zz" to the ini symlink name. This is sadly
				# coupled to the naming convention in the eclass.
				oldname="${ED}/${file/ext/ext-active}"
				newname="${oldname/${PHP_EXT_NAME}.ini/zz${PHP_EXT_NAME}.ini}"
				mv "${oldname}" "${newname}" \
					|| die "failed to rename ${oldname} to ${newname}"
				einfo "renamed ${oldname} to ${newname}"
			done
		done
	fi
}
