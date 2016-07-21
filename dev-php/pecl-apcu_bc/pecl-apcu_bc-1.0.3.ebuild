# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PHP_EXT_NAME="bc_apc"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="README.md"

USE_PHP="php7-0"

inherit php-ext-pecl-r2

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Provides APC backwards compatibility functions via APCu"
LICENSE="PHP-3.01"
SLOT="0"
IUSE=""

DEPEND="dev-php/pecl-apcu[php_targets_php7-0]"
RDEPEND="${DEPEND}"

src_install() {
	# Rename the apc.so to match the ini file loading requirement
	local slot
	for slot in $(php_get_slots); do
		php_init_slot_env ${slot}
		mv "modules/apc.so" "modules/${PHP_EXT_NAME}.so" || die
	done
	php-ext-pecl-r2_src_install
}
