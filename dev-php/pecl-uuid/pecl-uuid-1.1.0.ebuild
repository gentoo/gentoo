# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PHP_EXT_NAME="uuid"
PHP_EXT_INIT="yes"
PHP_EXT_ZENDEXT="no"
DOCS=( CREDITS )

USE_PHP="php7-1 php7-2 php7-3 php7-4"

inherit php-ext-pecl-r3

DESCRIPTION="A wrapper around libuuid"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="sys-apps/util-linux"
RDEPEND="${DEPEND}"
PHP_EXT_ECONF_ARGS=()
