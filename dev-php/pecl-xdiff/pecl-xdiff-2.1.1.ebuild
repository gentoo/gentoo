# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PHP_EXT_NAME="xdiff"
PHP_EXT_PECL_PKG="xdiff"
DOCS=( README.API )

USE_PHP="php7-4 php8-0 php8-1 php8-2"

inherit php-ext-pecl-r3

KEYWORDS="~amd64 ~x86"

DESCRIPTION="PHP extension for generating diff files"
LICENSE="PHP-3.01"
SLOT="7"

DEPEND="dev-libs/libxdiff"
RDEPEND="${DEPEND}"
PHP_EXT_ECONF_ARGS=()
