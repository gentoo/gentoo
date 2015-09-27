# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PHP_EXT_NAME="${PN}"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="ChangeLog NEWS README.md"

USE_PHP="php5-4 php5-5 php5-6"

inherit php-ext-source-r2

KEYWORDS="~amd64 ~x86"

DESCRIPTION="A fast drop-in replacement for the standard PHP serialize"
HOMEPAGE="https://github.com/${PN}/${PN}"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${PF}.tar.gz"

LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""

src_configure() {
	my_conf="--enable-${PN}"
	php-ext-source-r2_src_configure
}

src_test() {
	for slot in $(php_get_slots); do
		php_init_slot_env ${slot}
		NO_INTERACTION="yes" emake test \
			|| die "test suite failed for slot ${slot}"
	done
}
