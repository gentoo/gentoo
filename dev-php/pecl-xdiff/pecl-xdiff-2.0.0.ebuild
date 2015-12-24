# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PHP_EXT_NAME="xdiff"
PHP_EXT_PECL_PKG="xdiff"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="README.API"

USE_PHP="php7-0"

inherit php-ext-pecl-r2

KEYWORDS="~x86 ~amd64"

DESCRIPTION="PHP extension for generating diff files"
LICENSE="PHP-3.01"
SLOT="0"
IUSE=""

DEPEND="dev-libs/libxdiff"
RDEPEND="${DEPEND}"
