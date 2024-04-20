# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PHP_EXT_NAME="psr"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
PHP_EXT_ECONF_ARGS=""
DOCS=( README.md CHANGELOG.md )

USE_PHP="php8-1"

inherit php-ext-pecl-r3

KEYWORDS="~amd64"

DESCRIPTION="Provides the accepted PSR interfaces, so they can be used in an extension"
LICENSE="BSD-2"
SLOT="0"
IUSE=""
