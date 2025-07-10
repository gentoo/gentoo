# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PHP_EXT_NAME="memcached"
DOCS=( ChangeLog README.markdown )

USE_PHP="php8-2 php8-3"
PHP_EXT_NEEDED_USE="json(+)?,session(-)?"
MY_P="${PN/pecl-/}-${PV/_rc/RC}"
PHP_EXT_PECL_FILENAME="${MY_P}.tgz"

inherit php-ext-pecl-r3

DESCRIPTION="Interface PHP with memcached via libmemcached library"
LICENSE="PHP-3.01"
SLOT="7"
KEYWORDS="amd64 arm arm64 x86"
IUSE="igbinary json sasl +session test"

REQUIRED_USE="test? ( igbinary )"
RESTRICT="!test? ( test )"

# php-ext-pecl-r3 doesn't expose a $*_USEDEP so we roll our own
IGBINARY_DEPEND=""
for slot in ${USE_PHP} ; do
	IGBINARY_DEPEND+="dev-php/igbinary[php_targets_${slot}(-)?] "
done

COMMON_DEPEND="|| ( dev-libs/libmemcached-awesome[sasl(-)?] >=dev-libs/libmemcached-1.0.14[sasl(-)?] )
	sys-libs/zlib
	igbinary? ( ${IGBINARY_DEPEND} )
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

	# make test fails to pull in igbinary.so, so we run it ourselves with the correct setting strings
	local slot
	for slot in $(php_get_slots); do
		php_init_slot_env "${slot}"
		NO_INTERACTION="yes" "${PHPCLI}" run-tests.php -n -d "extension=${EXT_DIR}/igbinary.so" -d "extension=modules/memcached.so" || die
	done

	kill "$(<"${T}/memcached.pid")"
	return ${exit_status}
}
