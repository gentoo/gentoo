# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PHP_EXT_NAME="radius"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php7-4"
PHP_EXT_PECL_FILENAME="${PN/pecl-/}-${PV/_beta/b}.tgz"
PHP_EXT_S="${WORKDIR}/${PHP_EXT_PECL_FILENAME%.tgz}"
PHP_EXT_NEEDED_USE="pcntl(-),sockets(-)"

inherit php-ext-pecl-r3

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Provides support for RADIUS authentication (RFC 2865) and accounting (RFC 2866)"
LICENSE="BSD"
SLOT="0"
IUSE="examples"

S="${PHP_EXT_S}"
