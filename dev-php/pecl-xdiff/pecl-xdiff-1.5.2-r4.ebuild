# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PHP_EXT_NAME="xdiff"
PHP_EXT_PECL_PKG="xdiff"
DOCS="README.API"

USE_PHP="php5-6"

inherit php-ext-pecl-r3

KEYWORDS="~x86 ~amd64"

DESCRIPTION="PHP extension for generating diff files"
LICENSE="PHP-3.01"
SLOT="0"

DEPEND="dev-libs/libxdiff"
RDEPEND="${DEPEND}"
