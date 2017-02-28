# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PHP_EXT_NAME="bbcode"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS=( TODO )

USE_PHP="php5-6"

MY_PV="${PV/_beta/b}"
PECL_PKG_V="${PN/pecl-/}-${MY_PV}"
PHP_EXT_S="${WORKDIR}/${PECL_PKG_V}"

inherit php-ext-pecl-r3

KEYWORDS="~amd64 ~x86"

SRC_URI="http://pecl.php.net/get/${PECL_PKG_V}.tgz"
HOMEPAGE="http://pecl.php.net/package/bbcode"

DESCRIPTION="A quick and efficient BBCode Parsing Library"
LICENSE="PHP-3.01 BSD"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""

S="${PHP_EXT_S}"
