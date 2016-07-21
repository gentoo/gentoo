# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PHP_EXT_NAME="gnupg"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php5-6 php5-5 php5-4"

inherit php-ext-pecl-r2

KEYWORDS="~amd64 ~x86"
DESCRIPTION="PHP wrapper around the gpgme library"
LICENSE="BSD-2"
SLOT="0"
IUSE=""

DEPEND="app-crypt/gpgme"
RDEPEND="${DEPEND}"

src_prepare() {
	for slot in $(php_get_slots); do
		php_init_slot_env ${slot}
		epatch "${FILESDIR}"/1.3.2/01-large_file_system.patch
	done

	php-ext-source-r2_src_prepare
}
