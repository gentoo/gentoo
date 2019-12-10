# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PHP_EXT_NAME="memcached"
DOCS=( ChangeLog README.markdown )

USE_PHP="php5-6 php7-0 php7-1 php7-2 php7-3" # Pretend to support all four targets...
inherit php-ext-pecl-r3
USE_PHP="php7-0 php7-1 php7-2 php7-3" # But only truly build for these three.

DESCRIPTION="Interface PHP with memcached via libmemcached library"
LICENSE="PHP-3"
SLOT="7"
KEYWORDS="~amd64 x86"
IUSE="examples igbinary json sasl +session test"
RESTRICT="!test? ( test )"

COMMON_DEPEND=">=dev-libs/libmemcached-1.0.14[sasl?]
	sys-libs/zlib
	igbinary? ( dev-php/igbinary[php_targets_php7-0(-)?,php_targets_php7-1(-)?,php_targets_php7-2(-)?,php_targets_php7-3(-)?] )
"

DEPEND="
	php_targets_php7-0? (
		${COMMON_DEPEND} dev-lang/php:7.0[session?,json?]
	)
	php_targets_php7-1? (
		${COMMON_DEPEND} dev-lang/php:7.1[session?,json?]
	)
	php_targets_php7-2? (
		${COMMON_DEPEND} dev-lang/php:7.2[session?,json?]
	)
	php_targets_php7-3? (
		${COMMON_DEPEND} dev-lang/php:7.3[session?,json?]
	)
	test? ( net-misc/memcached )"
RDEPEND="
	php_targets_php7-0? (
		${COMMON_DEPEND} dev-lang/php:7.0[session?,json?]
	)
	php_targets_php7-1? (
		${COMMON_DEPEND} dev-lang/php:7.1[session?,json?]
	)
	php_targets_php7-2? (
		${COMMON_DEPEND} dev-lang/php:7.2[session?,json?]
	)
	php_targets_php7-3? (
		${COMMON_DEPEND} dev-lang/php:7.3[session?,json?]
	)"

src_prepare(){
	if use php_targets_php7-0 || use php_targets_php7-1 || use php_targets_php7-2 || use php_targets_php7-3 ; then
		php-ext-source-r3_src_prepare
	else
		default_src_prepare
	fi
}

src_configure() {
	local PHP_EXT_ECONF_ARGS="--enable-memcached
		$(use_enable session memcached-session)
		$(use_enable sasl memcached-sasl)
		$(use_enable json memcached-json)
		$(use_enable igbinary memcached-igbinary)"

	php-ext-source-r3_src_configure
}

src_test() {
	local memcached_opts=( -d -P "${T}/memcached.pid" -p 11211 -l 127.0.0.1 )
	[[ ${EUID} == 0 ]] && memcached_opts+=( -u portage )
	memcached "${memcached_opts[@]}" || die "Can't start memcached test server"

	local exit_status
	php-ext-source-r3_src_test
	exit_status=$?

	kill "$(<"${T}/memcached.pid")"
	return ${exit_status}
}

src_install(){
	if use php_targets_php7-0 || use php_targets_php7-1 || use php_targets_php7-2 || use php_targets_php7-3 ; then
		php-ext-source-r3_src_install
	fi
}
