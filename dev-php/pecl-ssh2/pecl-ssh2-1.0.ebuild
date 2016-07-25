# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PHP_EXT_NAME="ssh2"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php7-0 php5-6"

inherit php-ext-pecl-r3

USE_PHP="php7-0"

DESCRIPTION="PHP bindings for the libssh2 library"
LICENSE="PHP-3.01"
SLOT="7"
IUSE=""
KEYWORDS="~amd64 ~x86"
DEPEND=">=net-libs/libssh2-1.2"
RDEPEND="${DEPEND} php_targets_php5-6? ( dev-php/pecl-ssh2:0[php_targets_php5-6] )"
PHP_EXT_ECONF_ARGS=""
