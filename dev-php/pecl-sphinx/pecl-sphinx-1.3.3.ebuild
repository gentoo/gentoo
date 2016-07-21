# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PHP_EXT_NAME="sphinx"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php5-6 php5-5 php5-4"

inherit php-ext-pecl-r2

KEYWORDS="~amd64"

DESCRIPTION="PHP extension to execute search queries on a sphinx daemon"
LICENSE="PHP-3"
SLOT="0"
IUSE=""

RDEPEND="app-misc/sphinx"
DEPEND="${RDEPEND}
	>=dev-util/re2c-0.13"
