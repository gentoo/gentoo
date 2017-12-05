# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PHP_EXT_NAME="ps"
USE_PHP="php5-6 php7-0 php7-1 php7-2"

inherit php-ext-pecl-r3

# Only really build for 5.6
USE_PHP="php5-6"

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

DESCRIPTION="PHP extension for creating PostScript files"
LICENSE="PHP-2.02"
SLOT="0"
IUSE="examples"

DEPEND="php_targets_php5-6? ( dev-libs/pslib )"
RDEPEND="${DEPEND}"
PDEPEND="
	php_targets_php7-0? ( dev-php/pecl-ps:7[php_targets_php7-0] )
	php_targets_php7-1? ( dev-php/pecl-ps:7[php_targets_php7-1] )
	php_targets_php7-2? ( dev-php/pecl-ps:7[php_targets_php7-2] )
"
PHP_EXT_ECONF_ARGS=""

src_prepare() {
	if use php_targets_php5-6 ; then
		php-ext-source-r3_src_prepare
	else
		default_src_prepare
	fi
}

src_install() {
	if use php_targets_php5-6 ; then
		php-ext-pecl-r3_src_install
	fi
}
