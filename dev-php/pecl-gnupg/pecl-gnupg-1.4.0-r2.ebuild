# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

MY_P="${PN/pecl-/}-${PV/_rc/RC}"
PHP_EXT_NAME="gnupg"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
PHP_EXT_PECL_FILENAME="${MY_P}.tgz"
PHP_EXT_S="${WORKDIR}/${MY_P}"

USE_PHP="php5-6 php7-1 php7-2 php7-3 php7-4"

inherit php-ext-pecl-r3

S="${PHP_EXT_S}"

KEYWORDS="~amd64 ~x86"
DESCRIPTION="PHP wrapper around the gpgme library"
LICENSE="BSD-2"
SLOT="0"
IUSE=""

DEPEND="app-crypt/gpgme app-crypt/gnupg"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/1.3.2/01-large_file_system.patch )

# tests are broken with gnupg 2.0/2.1, see:
# https://github.com/php-gnupg/php-gnupg/issues/2
# https://github.com/php-gnupg/php-gnupg/issues/3
RESTRICT="test"
