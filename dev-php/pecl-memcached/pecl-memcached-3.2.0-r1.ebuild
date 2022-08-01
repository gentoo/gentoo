# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PHP_EXT_NAME="memcached"
DOCS=( ChangeLog README.markdown )

USE_PHP="php7-4 php8-0 php8-1"
PHP_EXT_NEEDED_USE="json(+)?,session(-)?"
MY_P="${PN/pecl-/}-${PV/_rc/RC}"
PHP_EXT_PECL_FILENAME="${MY_P}.tgz"
PHP_EXT_S="${WORKDIR}/${MY_P}"

inherit php-ext-pecl-r3

DESCRIPTION="Interface PHP with memcached via libmemcached library"
LICENSE="PHP-3.01"
SLOT="7"
KEYWORDS="~amd64 arm arm64 ~x86"
IUSE="igbinary json sasl +session test"

RESTRICT="!test? ( test )"

COMMON_DEPEND="|| ( dev-libs/libmemcached-awesome[sasl(-)?] >=dev-libs/libmemcached-1.0.14[sasl(-)?] )
	sys-libs/zlib
	igbinary? ( dev-php/igbinary[php_targets_php7-4(-)?,php_targets_php8-0(-)?,php_targets_php8-1(-)?] )
"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"
BDEPEND="${COMMON_DEPEND} test? ( net-misc/memcached )"

S="${WORKDIR}/${MY_P}"

src_configure() {
	local PHP_EXT_ECONF_ARGS="--enable-memcached
		$(use_enable session memcached-session)
		$(use_enable sasl memcached-sasl)
		$(use_enable json memcached-json)
		$(use_enable igbinary memcached-igbinary)"

	php-ext-source-r3_src_configure
}

src_test() {
	touch "${T}/memcached.pid" || die
	local memcached_opts=( -d -P "${T}/memcached.pid" -p 11211 -l 127.0.0.1 -U 11211 )
	[[ ${EUID} == 0 ]] && memcached_opts+=( -u portage )
	memcached "${memcached_opts[@]}" || die "Can't start memcached test server"

	local exit_status
	php-ext-source-r3_src_test
	exit_status=$?

	kill "$(<"${T}/memcached.pid")"
	return ${exit_status}
}
