# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PHP_EXT_NAME="redis"
USE_PHP="php5-6 php7-0 php7-1"
DOCS=( arrays.markdown README.markdown )

inherit php-ext-pecl-r3

DESCRIPTION="PHP extension for interfacing with Redis"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~amd64"
IUSE="igbinary"

DEPEND="igbinary? (
	php_targets_php5-6? ( dev-php/igbinary[php_targets_php5-6] )
	php_targets_php7-0? ( dev-php/igbinary[php_targets_php7-0] )
	php_targets_php7-1? ( dev-php/igbinary[php_targets_php7-1] ) )"
RDEPEND="${DEPEND}"

# The test suite requires network access.
RESTRICT=test

src_configure() {
	local PHP_EXT_ECONF_ARGS=(
		--enable-redis
		$(use_enable igbinary redis-igbinary)
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
