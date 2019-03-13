# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PHP_EXT_NAME="swoole"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
PHP_EXT_SAPIS="cli"
DOCS=( README.md )

USE_PHP="php7-0 php7-1 php7-2 php7-3"

inherit php-ext-pecl-r3

HOMEPAGE="https://www.swoole.co.uk"
KEYWORDS="~amd64 ~x86"

DESCRIPTION="Event-driven asynchronous & concurrent & coroutine networking engine"
LICENSE="Apache-2.0"
SLOT="0"

DEPEND="
	dev-libs/libaio
	dev-libs/boost:0=
	dev-libs/libpcre
	http2? ( net-libs/nghttp2:0= )
	redis? ( dev-libs/hiredis:0= )
	ssl? ( !libressl? ( dev-libs/openssl:0= ) libressl? ( dev-libs/libressl:0= ) )
	php_targets_php7-0? ( dev-lang/php:7.0[cli,sockets?] )
	php_targets_php7-1? ( dev-lang/php:7.1[cli,sockets?] )
	php_targets_php7-2? ( dev-lang/php:7.2[cli,sockets?] )
	php_targets_php7-3? ( dev-lang/php:7.3[cli,sockets?] )
	mysql? (
		php_targets_php7-0? ( dev-lang/php:7.0[mysql,mysqli(+)] )
		php_targets_php7-1? ( dev-lang/php:7.1[mysql,mysqli(+)] )
		php_targets_php7-2? ( dev-lang/php:7.2[mysql,mysqli(+)] )
		php_targets_php7-3? ( dev-lang/php:7.3[mysql,mysqli(+)] )
	)
"

RDEPEND="${DEPEND}"

IUSE="debug http2 libressl mysql redis sockets ssl threads"

src_configure() {
	# PostgreSQL disabled due to Gentoo's slot system
	local PHP_EXT_ECONF_ARGS=(
		--with-swoole
		--disable-coroutine-postgresql
		$(use_enable debug swoole-debug)
		$(use_enable http2)
		$(use_enable mysql mysqlnd)
		$(use_enable redis async_redis)
		$(use_enable ssl openssl)
		$(use_with ssl openssl-dir "${EROOT%/}/usr")
		$(use_enable threads thread)
		$(use_enable sockets)
	)

	php-ext-source-r3_src_configure
}

src_test() {
	local slot
	for slot in $(php_get_slots); do
		php_init_slot_env "${slot}"
		SKIP_ONLINE_TESTS="yes" NO_INTERACTION="yes" emake test
	done
}
