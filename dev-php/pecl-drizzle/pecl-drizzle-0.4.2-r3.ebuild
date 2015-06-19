# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/pecl-drizzle/pecl-drizzle-0.4.2-r3.ebuild,v 1.1 2015/02/17 01:07:11 grknight Exp $

EAPI="5"

PHP_EXT_NAME="drizzle"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php5-6 php5-5 php5-4"

inherit php-ext-pecl-r2 eutils

KEYWORDS="~amd64"

DESCRIPTION="PHP extension using libdrizzle library to provide communcation with Drizzle and MySQL databases"
LICENSE="PHP-3"
SLOT="0"
IUSE=""

DEPEND="dev-db/drizzle"
RDEPEND="${DEPEND}"

src_prepare() {
	local slot orig_s="${PHP_EXT_S}"
	for slot in $(php_get_slots); do
		php_init_slot_env ${slot}
		epatch "${FILESDIR}/${P}-php54.patch"
		#Fix tests
		mkdir ext || die
		mv drizzle_*.phpt ext || die
	done
	php-ext-source-r2_src_prepare
}
