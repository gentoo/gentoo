# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PHP_EXT_NAME="memcached"
DOCS=( ChangeLog README.markdown )

USE_PHP="php8-1 php8-2"
PHP_EXT_NEEDED_USE="json(+)?,session(-)?"
MY_P="${PN/pecl-/}-${PV/_rc/RC}"
PHP_EXT_PECL_FILENAME="${MY_P}.tgz"
GH_COMMIT="6926c53ac32a579b38a0dcc3c8aec662f8cd9dd5"
PHP_EXT_S="${WORKDIR}/php-memcached-${GH_COMMIT}"

inherit php-ext-pecl-r3

DESCRIPTION="Interface PHP with memcached via libmemcached library"
SRC_URI="https://github.com/php-memcached-dev/php-memcached/archive/${GH_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/php-memcached-${GH_COMMIT}"
LICENSE="PHP-3.01"
SLOT="7"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="igbinary json sasl +session test"

RESTRICT="!test? ( test )"

COMMON_DEPEND="|| ( dev-libs/libmemcached-awesome[sasl(-)?] >=dev-libs/libmemcached-1.0.14[sasl(-)?] )
	sys-libs/zlib
	igbinary? ( dev-php/igbinary[php_targets_php8-1(-)?,php_targets_php8-2(-)?] )
"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"
BDEPEND="${COMMON_DEPEND} test? ( net-misc/memcached )"

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
