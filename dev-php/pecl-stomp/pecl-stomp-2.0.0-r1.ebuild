# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

USE_PHP="php5-6 php7-0"
PHP_EXT_NAME="stomp"
DOCS=( CREDITS doc/classes.php doc/functions.php )

inherit php-ext-pecl-r3

USE_PHP="php7-0"

KEYWORDS="~amd64 ~x86"

DESCRIPTION="PHP extension to communicate with Stomp message brokers"
LICENSE="PHP-3.01"
SLOT="7"
IUSE="examples ssl test"

DEPEND="${DEPEND}
	php_targets_php7-0? ( dev-lang/php:7.0[ssl?] )
"

RDEPEND="${DEPEND}
	php_targets_php5-6? ( dev-php/pecl-stomp:0 )"

src_prepare() {
	if use php_targets_php7-0 ; then
		php-ext-source-r3_src_prepare
	else
		default_src_prepare
	fi
}

src_configure() {
	local PHP_EXT_ECONF_ARGS=(
		--enable-stomp
		--with-openssl-dir=$(usex ssl "${EPREFIX}/usr")
	)
	php-ext-source-r3_src_configure
}

src_install() {
	if use php_targets_php7-0 ; then
		php-ext-pecl-r3_src_install
	fi
}
