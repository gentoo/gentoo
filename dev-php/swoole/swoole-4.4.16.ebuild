# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PHP_EXT_NAME="swoole"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
PHP_EXT_SAPIS="cli"
DOCS=( README.md )

USE_PHP="php7-4"

inherit php-ext-pecl-r3

HOMEPAGE="https://www.swoole.co.uk"
KEYWORDS="~amd64 ~x86"

DESCRIPTION="Event-driven asynchronous & concurrent & coroutine networking engine"
LICENSE="Apache-2.0"
SLOT="0"
# Tests can hang.  Disable until this no longer happens
RESTRICT="test"

DEPEND="
	app-arch/brotli:0=
	dev-libs/libaio
	dev-libs/boost:=
	dev-libs/libpcre
	sys-libs/zlib:0=
	http2? ( net-libs/nghttp2:0= )
	ssl? (
		dev-libs/openssl:0=
	)
	php_targets_php7-4? ( dev-lang/php:7.4[cli,sockets?] )
	mysql? (
		php_targets_php7-4? ( dev-lang/php:7.4[mysql,mysqli(+)] )
	)
"

RDEPEND="${DEPEND}"

IUSE="debug http2 mysql sockets ssl"

src_configure() {
	# JEMalloc not included as it refuses to find a ${ESYSROOT}/usr/includes/jemalloc subdirectory
	local PHP_EXT_ECONF_ARGS=(
		--enable-swoole
		$(use_enable debug)
		$(use_enable http2)
		$(use_enable mysql mysqlnd)
		$(use_enable ssl openssl)
		$(use_with ssl openssl-dir "${ESYSROOT}/usr")
		$(use_enable sockets)
	)

	php-ext-source-r3_src_configure
}

src_test() {
	local slot
	for slot in $(php_get_slots); do
		php_init_slot_env "${slot}"
		[[ -f tests/template.phpt ]] && rm tests/template.phpt
		SKIP_ONLINE_TESTS="yes" NO_INTERACTION="yes" emake test
	done
}
