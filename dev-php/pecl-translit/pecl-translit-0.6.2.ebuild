# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PHP_EXT_NAME="translit"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php7-0 php5-6 php5-5"
PHP_EXT_NAME="translit"

MY_PV="${PV//./_}"
S="${WORKDIR}/${PN}-RELEASE_${MY_PV}"

inherit php-ext-source-r2

SRC_URI="https://github.com/derickr/${PN}/archive/RELEASE_${MY_PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
HOMEPAGE="https://github.com/derickr/pecl-translit"

DESCRIPTION="Transliterates non-latin character sets to latin"
LICENSE="BSD-2"
SLOT="0"
IUSE=""

src_test() {
	for slot in $(php_get_slots); do
		php_init_slot_env ${slot}
		NO_INTERACTION="yes" emake test || die "emake test failed for slot ${slot}"
	done
}
