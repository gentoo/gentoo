# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

PHP_EXT_NAME="raphf"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php5-6 php7-0"

inherit php-ext-pecl-r3

# Only really build for 7.0
USE_PHP="php7-0"

KEYWORDS="~amd64 ~x86"

DESCRIPTION="A reusable, persistent handle and resource factory API"
LICENSE="BSD-2"
SLOT="7"
IUSE=""

RDEPEND="php_targets_php5-6? ( ${CATEGORY}/${PN}:0[php_targets_php5-6] )"

src_prepare() {
	if use php_targets_php7-0 ; then
		php-ext-source-r3_src_prepare
	else
		default_src_prepare
	fi
}
