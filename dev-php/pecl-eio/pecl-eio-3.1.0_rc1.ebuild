# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/pecl-}"
MY_PV="${PV/_rc/RC}"
MY_P="${MY_PN}-${MY_PV}"
PHP_EXT_NAME="eio"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
PHP_EXT_PECL_FILENAME="${MY_P}.tgz"
PHP_EXT_S="${WORKDIR}/${MY_P}"
DOCS=( README.md )

USE_PHP="php8-1"
inherit php-ext-pecl-r3

DESCRIPTION="PHP wrapper for libeio library"
S="${PHP_EXT_S}"

LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

src_configure() {
	local PHP_EXT_ECONF_ARGS=("--with-eio" "$(use_enable debug eio-debug)" )
	php-ext-source-r3_src_configure
}
