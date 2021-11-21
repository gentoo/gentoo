# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

USE_PHP="php7-2 php7-3 php7-4 php8-0"

MY_PV="${PV/_rc/RC}"
PHP_EXT_PECL_FILENAME="dbase-${MY_PV}.tgz"

inherit php-ext-pecl-r3

KEYWORDS="~amd64 ~x86"

DESCRIPTION="dBase database file access functions"
LICENSE="PHP-3.01"
SLOT="7"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PHP_EXT_PECL_FILENAME%.tgz}"
PHP_EXT_S="${S}"
