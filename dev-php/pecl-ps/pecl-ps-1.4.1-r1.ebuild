# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PHP_EXT_NAME="ps"
USE_PHP="php7-3 php7-4"

inherit php-ext-pecl-r3

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

DESCRIPTION="PHP extension for creating PostScript files"
LICENSE="BSD"
SLOT="7"
IUSE="examples"

DEPEND="dev-libs/pslib"
RDEPEND="${DEPEND}"
PHP_EXT_ECONF_ARGS=""

src_test() {
	# tests/004.phpt depends on set numeric format
	LC_ALL=C php-ext-pecl-r3_src_test
}
