# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PHP_EXT_NAME="radius"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php5-6 php7-0 php7-1 php7-2"
PHP_EXT_PECL_FILENAME="${PN/pecl-/}-${PV/_beta/b}.tgz"
PHP_EXT_S="${WORKDIR}/${PHP_EXT_PECL_FILENAME%.tgz}"

inherit php-ext-pecl-r3

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Provides support for RADIUS authentication (RFC 2865) and accounting (RFC 2866)"
LICENSE="BSD"
SLOT="0"
IUSE="examples"

S="${PHP_EXT_S}"

RDEPEND="
	php_targets_php5-6? ( dev-lang/php:5.6[pcntl,sockets] )
	php_targets_php7-0? ( dev-lang/php:7.0[pcntl,sockets] )
	php_targets_php7-1? ( dev-lang/php:7.1[pcntl,sockets] )
	php_targets_php7-2? ( dev-lang/php:7.2[pcntl,sockets] )
"
