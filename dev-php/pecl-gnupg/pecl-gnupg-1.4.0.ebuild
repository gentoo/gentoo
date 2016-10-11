# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

MY_P="${PN/pecl-/}-${PV/_rc/RC}"
PHP_EXT_NAME="gnupg"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
PHP_EXT_PECL_FILENAME="${MY_P}.tgz"
PHP_EXT_S="${WORKDIR}/${MY_P}"

USE_PHP="php5-6 php7-0"

inherit php-ext-pecl-r3

S="${PHP_EXT_S}"

KEYWORDS="~amd64 ~x86"
DESCRIPTION="PHP wrapper around the gpgme library"
LICENSE="BSD-2"
SLOT="0"
IUSE=""

DEPEND="app-crypt/gpgme <app-crypt/gnupg-2"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/1.3.2/01-large_file_system.patch )
