# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PHP_EXT_NAME="radius"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php5-6"

inherit php-ext-pecl-r3

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Provides support for RADIUS authentication (RFC 2865) and accounting (RFC 2866)"
LICENSE="BSD"
SLOT="0"
IUSE="examples"

RDEPEND="php_targets_php5-6? ( dev-lang/php:5.6[pcntl,sockets] )"
