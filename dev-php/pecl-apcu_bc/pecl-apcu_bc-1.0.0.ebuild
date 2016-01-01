# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PHP_EXT_NAME="apc"
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
