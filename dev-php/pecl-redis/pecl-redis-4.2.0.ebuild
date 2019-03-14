# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PHP_EXT_NAME="redis"
USE_PHP="php5-6 php7-0 php7-1 php7-2 php7-3"
DOCS=( arrays.markdown cluster.markdown README.markdown CREDITS )
MY_P="${PN/pecl-/}-${PV/_rc/RC}"
PHP_EXT_PECL_FILENAME="${MY_P}.tgz"
PHP_EXT_S="${WORKDIR}/${MY_P}"

inherit php-ext-pecl-r3

DESCRIPTION="PHP extension for interfacing with Redis"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="amd64 ~arm"
IUSE="igbinary +session"

DEPEND="
	php_targets_php5-6? ( dev-lang/php:5.6[session?] igbinary? ( dev-php/igbinary[php_targets_php5-6] ) )
	php_targets_php7-0? ( dev-lang/php:7.0[session?] igbinary? ( dev-php/igbinary[php_targets_php7-0] ) )
	php_targets_php7-1? ( dev-lang/php:7.1[session?] igbinary? ( dev-php/igbinary[php_targets_php7-1] ) )
	php_targets_php7-2? ( dev-lang/php:7.2[session?] igbinary? ( dev-php/igbinary[php_targets_php7-2] ) )
	php_targets_php7-3? ( dev-lang/php:7.3[session?] igbinary? ( dev-php/igbinary[php_targets_php7-3] ) )
"
RDEPEND="${DEPEND} !dev-php/pecl-redis:7"

# The test suite requires network access.
RESTRICT=test

S="${WORKDIR}/${MY_P}"

src_configure() {
	local PHP_EXT_ECONF_ARGS=(
		--enable-redis
		$(use_enable igbinary redis-igbinary)
		$(use_enable session redis-session)
	)
	php-ext-source-r3_src_configure
}

src_test(){
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

pkg_postinst() {
	elog "The 4.0 release comes with breaking API changes."
	elog "Be sure to verify any applications upon upgrading."
}
