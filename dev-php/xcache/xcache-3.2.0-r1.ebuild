# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PHP_EXT_NAME="xcache"
PHP_EXT_SAPIS="apache2 cgi fpm"
USE_PHP="php5-5 php5-6"

inherit php-ext-source-r3 confutils

DESCRIPTION="A fast and stable PHP opcode cacher"
HOMEPAGE="http://xcache.lighttpd.net/"
SRC_URI="http://xcache.lighttpd.net/pub/Releases/${PV}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="coverage"

# make test would just run php's test and as such need the full php source
RESTRICT="test"

DEPEND="
	!dev-php/eaccelerator
	!dev-php/pecl-apc
	virtual/httpd-php:*
	php_targets_php5-5? ( !dev-lang/php:5.5[opcache] )
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README THANKS )

src_configure() {
	PHP_EXT_ECONF_ARGS=(
		--enable-xcache=shared
		--enable-xcache-constant  \
		--enable-xcache-optimizer \
		$(use_enable coverage xcache-coverager) \
		--enable-xcache-assembler \
		--enable-xcache-encoder   \
		--enable-xcache-decoder )

	php-ext-source-r3_src_configure
}

src_install() {
	php-ext-source-r3_src_install

	insinto "${PHP_EXT_SHARED_DIR}"
	doins lib/Decompiler.class.php

	# Install the admin interface somewhere where it can be
	# copied/symlinked into a document root.
	insinto "/usr/share/${PN}"
	doins -r htdocs
}

pkg_postinst() {
	elog "The lib/Decompiler.class.php file shipped with this release"
	elog "was installed into ${PHP_EXT_SHARED_DIR}. The htdocs/ admin"
	elog "interface directory can be found under ${EPREFIX}/usr/share/${PN}."
}
