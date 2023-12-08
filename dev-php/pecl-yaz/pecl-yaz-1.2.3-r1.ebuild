# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PHP_EXT_NAME="yaz"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS=( README )

USE_PHP="php8-0"

inherit php-ext-pecl-r3

KEYWORDS="amd64 arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc x86"

DESCRIPTION="This extension implements a Z39.50 client for PHP using the YAZ toolkit"
LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=">=dev-libs/yaz-3.0.2:0="
RDEPEND="${DEPEND}"

# Needs network access
RESTRICT="test"

PHP_EXT_ECONF_ARGS="--with-yaz=/usr"

PATCHES=( "${FILESDIR}/${PV}" )
