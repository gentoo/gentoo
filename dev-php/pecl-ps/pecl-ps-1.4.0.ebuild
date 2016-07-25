# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PHP_EXT_NAME="ps"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php5-6 php7-0"

inherit php-ext-pecl-r3

# Only really build for 7.0
USE_PHP="php7-0"

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

DESCRIPTION="PHP extension for creating PostScript files"
LICENSE="PHP-2.02"
SLOT="7"
IUSE="examples"

DEPEND="dev-libs/pslib"
RDEPEND="${DEPEND} php_targets_php5-6? ( dev-php/pecl-ps:0[php_targets_php5-6] )"
PHP_EXT_ECONF_ARGS=""
