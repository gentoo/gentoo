# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PHP_EXT_NAME="ps"
USE_PHP="php5-6 php7-1 php7-2 php7-3 php7-4"

inherit php-ext-pecl-r3

# Only really build for >=7.0
USE_PHP="php7-1 php7-2 php7-3 php7-4"

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

DESCRIPTION="PHP extension for creating PostScript files"
LICENSE="BSD"
SLOT="7"
IUSE="examples"

DEPEND="
	php_targets_php7-1? ( dev-libs/pslib )
	php_targets_php7-2? ( dev-libs/pslib )
	php_targets_php7-3? ( dev-libs/pslib )
	php_targets_php7-4? ( dev-libs/pslib )
"
RDEPEND="${DEPEND} php_targets_php5-6? ( dev-php/pecl-ps:0[php_targets_php5-6] )"
PHP_EXT_ECONF_ARGS=""

src_prepare() {
	if use php_targets_php7-1 || use php_targets_php7-2 || use php_targets_php7-3 || use php_targets_php7-4 ; then
		php-ext-source-r3_src_prepare
	else
		default_src_prepare
	fi
}

src_install() {
	if use php_targets_php7-1 || use php_targets_php7-2 || use php_targets_php7-3 || use php_targets_php7-4 ; then
		php-ext-pecl-r3_src_install
	fi
}

src_test() {
	if use php_targets_php7-1 || use php_targets_php7-2 || use php_targets_php7-3 || use php_targets_php7-4 ; then
		# tests/004.phpt depends on set numeric format
		LC_ALL=C php-ext-pecl-r3_src_test
	fi
}
