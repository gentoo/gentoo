# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PHP_EXT_NAME="xcache"
PHP_EXT_INI="yes"
PHPSAPILIST="apache2 cgi fpm"
USE_PHP="php5-4 php5-5"

inherit php-ext-source-r2 confutils

DESCRIPTION="A fast and stable PHP opcode cacher"
HOMEPAGE="http://xcache.lighttpd.net/"
SRC_URI="http://xcache.lighttpd.net/pub/Releases/${PV}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# make test would just run php's test and as such need the full php source
RESTRICT="test"

DEPEND="
	!dev-php/eaccelerator
	!dev-php/pecl-apc
	virtual/httpd-php
	php_targets_php5-5? ( !dev-lang/php:5.5[opcache] )
"
RDEPEND="${DEPEND}"

src_configure() {

	my_conf="--enable-xcache=shared   \
			--enable-xcache-constant  \
			--enable-xcache-optimizer \
			--enable-xcache-coverager \
			--enable-xcache-assembler \
			--enable-xcache-encoder   \
			--enable-xcache-decoder"

	php-ext-source-r2_src_configure
}

src_install() {
	php-ext-source-r2_src_install
	dodoc AUTHORS ChangeLog NEWS README THANKS

	insinto "${PHP_EXT_SHARED_DIR}"
	doins lib/Decompiler.class.php
	insinto "${PHP_EXT_SHARED_DIR}"
	doins -r htdocs
}

pkg_postinst() {
	elog "lib/Decompiler.class.php, and the htdocs/ directory shipped with this"
	elog "release were installed into ${PHP_EXT_SHARED_DIR}."
}
