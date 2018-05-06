# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PHP_EXT_NAME="event"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS=( README.md )

USE_PHP="php5-6 php7-0 php7-1 php7-2"

inherit php-ext-pecl-r3

KEYWORDS="~amd64 ~ia64 ~x86"
LICENSE="PHP-3.01"

DESCRIPTION="PHP wrapper for libevent2"
LICENSE="PHP-3"
SLOT="0"

DEPEND="
	>=dev-libs/libevent-2.0.2
	ssl? ( !libressl? ( dev-libs/openssl:0= ) libressl? ( dev-libs/libressl:0= ) )
	php_targets_php5-6? ( dev-lang/php:5.6[sockets?] )
	php_targets_php7-0? ( dev-lang/php:7.0[sockets?] )
	php_targets_php7-1? ( dev-lang/php:7.1[sockets?] )
	php_targets_php7-2? ( dev-lang/php:7.2[sockets?] )"

RDEPEND="${DEPEND} !dev-php/pecl-libevent"

IUSE="debug examples +extra libressl +sockets +ssl threads"

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
