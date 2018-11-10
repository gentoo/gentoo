# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PHP_EXT_NAME="mcrypt"
USE_PHP="php7-2"
MY_P="${PN/pecl-/}-${PV/_rc/RC}"
PHP_EXT_PECL_FILENAME="${MY_P}.tgz"
PHP_EXT_S="${WORKDIR}/${MY_P}"

inherit php-ext-pecl-r3

DESCRIPTION="Bindings for the libmcrypt library"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-libs/libmcrypt"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# PHP Warning: Use of undefined constant MCRYPT_CBC - assumed 'MCRYPT_CBC'
	sed -i '/MODE3/s/MCRYPT_CBC/"MCRYPT_CBC"/g' tests/bug8040.phpt || die

	php-ext-source-r3_src_prepare
}
