# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PHP_EXT_NAME="swoole"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
PHP_EXT_SAPIS="cli"
PHP_EXT_NEEDED_USE="cli,sockets?"
DOCS=( README.md )

USE_PHP="php8-1"

inherit php-ext-pecl-r3

HOMEPAGE="https://www.swoole.co.uk"
KEYWORDS="amd64 ~x86"

DESCRIPTION="Event-driven asynchronous & concurrent & coroutine networking engine"
LICENSE="Apache-2.0"
SLOT="0"
# Tests require network access for composer libraries under tests/include/lib/vendor
RESTRICT="test"

DEPEND="
	app-arch/brotli:0=
	dev-libs/libpcre
	sys-libs/zlib:0=
	ssl? (
		dev-libs/openssl:0=
	)
	mysql? (
		php_targets_php8-1? ( dev-lang/php:8.1[mysql,mysqli(+)] )
	)
"

RDEPEND="${DEPEND}"

IUSE="debug http2 mysql sockets ssl"

PATCHES=(
	"${FILESDIR}"/${P}-gcc13.patch
)

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
	ulimit -n 16384 > /dev/null 2>&1
	local slot
	for slot in $(php_get_slots); do
		php_init_slot_env "${slot}"
		cd tests || die
		if has_version ">=dev-php/xdebug-3" ; then
			sed -i 's/xdebug.default_enable=0/xdebug.mode=off/' run-tests || die
		fi
		PHPT=1 "${PHPCLI}" -d "memory_limit=1024m" ./run-tests swoole_* || die
	done
}
