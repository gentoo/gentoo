# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PHP_EXT_NAME="sphinx"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php5-6"

inherit php-ext-pecl-r3

KEYWORDS="~amd64"

DESCRIPTION="PHP extension to execute search queries on a sphinx daemon"
LICENSE="PHP-3"
SLOT="0"
IUSE=""

RDEPEND="app-misc/sphinx"
DEPEND="${RDEPEND}
	>=dev-util/re2c-0.13"
