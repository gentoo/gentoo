# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_PHP="php5-6 php7-0"

inherit php-ext-pecl-r3

SRC_URI+=" https://dev.gentoo.org/~grknight/distfiles/${P}-php7.patch.xz"

DESCRIPTION="Terminal screen handling and optimization package"

LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="sys-libs/ncurses:0="
RDEPEND="${DEPEND}"

PHP_EXT_ECONF_ARGS=( --enable-ncursesw )
PATCHES=( "${WORKDIR}/${P}-php7.patch" )
