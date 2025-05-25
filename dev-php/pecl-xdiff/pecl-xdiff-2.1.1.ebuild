# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PHP_EXT_NAME="xdiff"
PHP_EXT_PECL_PKG="xdiff"
DOCS=( README.API )

USE_PHP="php8-2 php8-3 php8-4"

inherit php-ext-pecl-r3

DESCRIPTION="PHP extension for generating diff files"
LICENSE="PHP-3.01"

SLOT="7"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/libxdiff"
DEPEND="${RDEPEND}"
PHP_EXT_ECONF_ARGS=()
