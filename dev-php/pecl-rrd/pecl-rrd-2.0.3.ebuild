# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

USE_PHP="php7-4 php8-0 php8-1 php8-2"

inherit php-ext-pecl-r3

DESCRIPTION="RRDtool bindings for PHP"
LICENSE="BSD"
SLOT="7"
KEYWORDS="~amd64 ~x86"

DEPEND="net-analyzer/rrdtool[graph(-)]"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

#PATCHES=( "${FILESDIR}/${PV}" )
PHP_EXT_ECONF_ARGS=()

src_test() {
	local slot
	for slot in $(php_get_slots); do
		php_init_slot_env "${slot}"
		# Prepare test data
		emake -C tests/data all
		NO_INTERACTION="yes" emake test
	done
}
