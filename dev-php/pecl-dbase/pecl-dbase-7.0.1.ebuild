# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

USE_PHP="php7-2 php7-3 php7-4"

inherit php-ext-pecl-r3

KEYWORDS="~amd64 ~x86"

DESCRIPTION="dBase database file access functions"
LICENSE="PHP-3.01"
SLOT="7"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
PHP_EXT_ECONF_ARGS=( )
