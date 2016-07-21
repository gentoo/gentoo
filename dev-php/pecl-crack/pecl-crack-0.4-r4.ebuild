# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PHP_EXT_NAME="crack"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="EXPERIMENTAL"

USE_PHP="php5-6 php5-5 php5-4"

inherit php-ext-pecl-r2

KEYWORDS="amd64 ppc ppc64 x86"

DESCRIPTION="PHP interface to the cracklib libraries"
LICENSE="PHP-3 CRACKLIB"
SLOT="0"
IUSE=""

src_prepare() {
	local slot
	for slot in $(php_get_slots) ; do
		cd "${WORKDIR}/${slot}"
		epatch "${FILESDIR}/fix-php-5-4-support.patch"
		# Patch for http://pecl.php.net/bugs/bug.php?id=5765
		epatch "${FILESDIR}/fix-pecl-bug-5765.patch"
	done
	php-ext-source-r2_src_prepare
}
