# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PHP_EXT_NAME="crack"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
PHP_EXT_EXTRA_ECONF=""
DOCS=( EXPERIMENTAL )

USE_PHP="php5-6 php7-0 php7-1"

inherit php-ext-pecl-r3

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

DESCRIPTION="PHP interface to the cracklib libraries"
LICENSE="PHP-3 CRACKLIB"
SLOT="0"
IUSE=""
# Patch for http://pecl.php.net/bugs/bug.php?id=5765
PATCHES=( "${FILESDIR}/fix-php-5-4-support.patch"
"${FILESDIR}/fix-pecl-bug-5765.patch"
"${FILESDIR}/${PV}-php7.patch"
)
