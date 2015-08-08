# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PHP_EXT_NAME="http"
PHP_EXT_PECL_PKG="pecl_http"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="docs/examples/tutorial.txt ThanksTo.txt KnownIssues.txt"

# Does not compile with php5-6
USE_PHP="php5-5 php5-4"

inherit php-ext-pecl-r2 php-ext-source-r2

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Extended HTTP Support for PHP"
LICENSE="BSD-2 MIT"
SLOT="0"
IUSE=""

for target in ${USE_PHP}; do
	slot=${target/php}
	slot=${slot/-/.}
	PHPUSEDEPEND="${PHPUSEDEPEND}
	php_targets_${target}? ( dev-lang/php:${slot}[hash,session,iconv] )"
done

DEPEND="net-misc/curl
	sys-libs/zlib
	dev-libs/libevent
	${PHPUSEDEPEND}
	"
RDEPEND="${DEPEND}"

my_conf="--enable-http \
		--with-http-curl-requests \
		--with-http-zlib-compression \
		--with-http-curl-libevent \
		--with-http-magic-mime"

src_install() {
	php-ext-pecl-r2_src_install

	php-ext-source-r2_addtoinifiles "http.etag.mode" "MD5"
	php-ext-source-r2_addtoinifiles "http.force_exit" "1"
	php-ext-source-r2_addtoinifiles "http.log.allowed_methods" ""
	php-ext-source-r2_addtoinifiles "http.log.cache" ""
	php-ext-source-r2_addtoinifiles "http.log.composite" ""
	php-ext-source-r2_addtoinifiles "http.log.not_found" ""
	php-ext-source-r2_addtoinifiles "http.log.redirect" ""
	php-ext-source-r2_addtoinifiles "http.only_exceptions" "0"
	php-ext-source-r2_addtoinifiles "http.persistent.handles.ident" "GLOBAL"
	php-ext-source-r2_addtoinifiles "http.persistent.handles.limit" "-1"
	php-ext-source-r2_addtoinifiles "http.request.datashare.connect" "0"
	php-ext-source-r2_addtoinifiles "http.request.datashare.cookie" "0"
	php-ext-source-r2_addtoinifiles "http.request.datashare.dns" "1"
	php-ext-source-r2_addtoinifiles "http.request.datashare.ssl" "0"
	php-ext-source-r2_addtoinifiles "http.request.methods.allowed" ""
	php-ext-source-r2_addtoinifiles "http.request.methods.custom" ""
	php-ext-source-r2_addtoinifiles "http.send.inflate.start_auto" "0"
	php-ext-source-r2_addtoinifiles "http.send.inflate.start_flags" "0"
	php-ext-source-r2_addtoinifiles "http.send.deflate.start_auto" "0"
	php-ext-source-r2_addtoinifiles "http.send.deflate.start_flags" "0"
	php-ext-source-r2_addtoinifiles "http.send.not_found_404" "1"
}
