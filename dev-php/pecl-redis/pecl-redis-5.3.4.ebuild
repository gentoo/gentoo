# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PHP_EXT_NAME="redis"
USE_PHP="php7-3 php7-4 php8-0"
PHP_EXT_NEEDED_USE="json(+)?,session(-)?"
DOCS=( arrays.markdown cluster.markdown README.markdown CREDITS )
MY_P="${PN/pecl-/}-${PV/_rc/RC}"
PHP_EXT_PECL_FILENAME="${MY_P}.tgz"
PHP_EXT_S="${WORKDIR}/${MY_P}"

inherit php-ext-pecl-r3

DESCRIPTION="PHP extension for interfacing with Redis"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE="igbinary +json lz4 +session zstd"

DEPEND="
	igbinary? ( >=dev-php/igbinary-3.0.1-r1[php_targets_php7-3(-)?,php_targets_php7-4(-)?,php_targets_php8-0(-)?] )
	lz4? ( app-arch/lz4:= )
	zstd? ( app-arch/zstd:= )
"
RDEPEND="${DEPEND}
	!dev-php/pecl-redis:7"

# The test suite requires network access.
RESTRICT=test

S="${WORKDIR}/${MY_P}"

src_configure() {
	local PHP_EXT_ECONF_ARGS=(
		--enable-redis
		--disable-redis-lzf
		--disable-redis-msgpack
		$(use_enable igbinary redis-igbinary)
		$(use_enable json redis-json)
		$(use_enable lz4 redis-lz4)
		$(use_with lz4 liblz4)
		$(use_enable session redis-session)
		$(use_enable zstd redis-zstd)
		$(use_with zstd libzstd)
	)
	php-ext-source-r3_src_configure
}

src_test() {
	local slot
	for slot in $(php_get_slots); do
		php_init_slot_env "${slot}"
		# Run tests for Redis class
		${PHPCLI} -d extension=modules/redis.so \
				  tests/TestRedis.php \
				  --class Redis \
				  --host ${PECL_REDIS_HOST} || die 'test suite failed'
	done
}
