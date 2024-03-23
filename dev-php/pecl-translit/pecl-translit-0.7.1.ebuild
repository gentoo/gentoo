# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PHP_EXT_NAME="translit"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php8-1"

inherit php-ext-source-r3

SRC_URI="https://github.com/derickr/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
HOMEPAGE="https://github.com/derickr/pecl-translit"

DESCRIPTION="Transliterates non-latin character sets to latin"
LICENSE="BSD-2"
SLOT="0"
IUSE=""
PHP_EXT_ECONF_ARGS=()

src_test() {
	for slot in $(php_get_slots); do
		php_init_slot_env ${slot}
		NO_INTERACTION="yes" emake test
	done
}
