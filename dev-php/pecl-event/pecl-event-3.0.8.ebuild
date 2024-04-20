# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PHP_EXT_NAME="event"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS=( README.md )

USE_PHP="php8-1 php8-2"
PHP_EXT_NEEDED_USE="sockets(-)?"

inherit php-ext-pecl-r3

KEYWORDS="amd64 x86"
LICENSE="PHP-3.01"

DESCRIPTION="PHP wrapper for libevent2"
SLOT="0"
IUSE="debug examples +extra +sockets +ssl threads"

DEPEND="
	>=dev-libs/libevent-2.0.2
	ssl? ( dev-libs/openssl:0= )"

RDEPEND="
	${DEPEND}
	!dev-php/pecl-libevent"

src_configure() {
	local PHP_EXT_ECONF_ARGS=(
		--with-event-core
		$(use_enable debug event-debug)
		$(use_with extra event-extra)
		$(use_with ssl event-openssl)
		$(use_with threads event-pthreads)
		$(use_enable sockets event-sockets)
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
