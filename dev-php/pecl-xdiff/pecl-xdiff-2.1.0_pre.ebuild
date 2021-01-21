# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PHP_EXT_NAME="xdiff"
PHP_EXT_PECL_PKG="xdiff"
DOCS=( README.API )

USE_PHP="php7-3 php7-4 php8-0"
PHP_EXT_PECL_FILENAME="${PN/pecl-/}-2.0.1.tgz"

inherit php-ext-pecl-r3

KEYWORDS="~amd64 ~x86"

DESCRIPTION="PHP extension for generating diff files"
LICENSE="PHP-3.01"
SLOT="7"

DEPEND="dev-libs/libxdiff"
RDEPEND="${DEPEND}"
PHP_EXT_ECONF_ARGS=()
PATCHES=(
"${FILESDIR}/2.1.0_pre-php8.patch"
"${FILESDIR}/2.1.0_pre-php8-2.patch"
"${FILESDIR}/2.1.0_pre-php8-3.patch"
)
S="${WORKDIR}/${PHP_EXT_PECL_FILENAME/.tgz/}"
PHP_EXT_S="${S}"
