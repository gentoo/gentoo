# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PHP_EXT_NAME="event"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="CREDITS EXPERIMENTAL INSTALL.md README.md LICENSE"

USE_PHP="php5-4 php5-5"

inherit php-ext-pecl-r2 confutils eutils

KEYWORDS="amd64 ia64 x86"
LICENSE="PHP-3.01"

DESCRIPTION="PHP wrapper for libevent2"
LICENSE="PHP-3"
SLOT="0"

DEPEND="
	>=dev-libs/libevent-2.0.2
	!dev-php/pecl-libevent
	sockets? ( dev-lang/php:*[sockets] )"

RDEPEND="${DEPEND}"

IUSE="debug +extra +ssl threads +sockets examples"

src_configure() {
	my_conf="--with-event-core"
	enable_extension_enable "event-debug" "debug" 0

	enable_extension_with "event-extra" "extra" 1
	enable_extension_with "event-openssl" "ssl" 1
	enable_extension_with "event-pthreads" "threads" 0
	enable_extension_enable "event-sockets" "sockets" 1

	php-ext-source-r2_src_configure
}
