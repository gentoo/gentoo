# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

PHP_EXT_NAME="event"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS=( README.md )

USE_PHP="php5-5 php5-6 php7-0"

inherit php-ext-pecl-r3

KEYWORDS="~amd64 ~ia64 ~x86"
LICENSE="PHP-3.01"

DESCRIPTION="PHP wrapper for libevent2"
LICENSE="PHP-3"
SLOT="0"

DEPEND="
	>=dev-libs/libevent-2.0.2
	php_targets_php5-5? ( dev-lang/php:5.5[sockets?] )
	php_targets_php5-6? ( dev-lang/php:5.6[sockets?] )
	php_targets_php7-0? ( dev-lang/php:7.0[sockets?] )"

RDEPEND="${DEPEND} !dev-php/pecl-libevent"

IUSE="debug +extra +ssl threads +sockets examples"

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
