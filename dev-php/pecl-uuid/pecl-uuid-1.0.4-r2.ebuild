# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PHP_EXT_NAME="uuid"
PHP_EXT_INIT="yes"
PHP_EXT_ZENDEXT="no"
DOCS=( CREDITS )

USE_PHP="php5-6 php7-0 php7-1 php7-2"

inherit php-ext-pecl-r3

DESCRIPTION="A wrapper around libuuid"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="sys-apps/util-linux"
RDEPEND="${DEPEND}"
PHP_EXT_ECONF_ARGS=()
