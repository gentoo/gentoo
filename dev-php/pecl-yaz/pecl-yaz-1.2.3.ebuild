# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PHP_EXT_NAME="yaz"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS=( README )

USE_PHP="php5-6 php7-0 php7-1 php7-2 php7-3 php7-4"

inherit php-ext-pecl-r3

KEYWORDS="~alpha amd64 arm hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc x86"

DESCRIPTION="This extension implements a Z39.50 client for PHP using the YAZ toolkit"
LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=">=dev-libs/yaz-3.0.2:0="
RDEPEND="${DEPEND}"

# Needs network access
RESTRICT="test"

PHP_EXT_ECONF_ARGS="--with-yaz=/usr"
