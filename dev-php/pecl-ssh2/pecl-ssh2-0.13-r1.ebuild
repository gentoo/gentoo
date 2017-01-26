# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PHP_EXT_NAME="ssh2"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php7-0 php5-6"

inherit php-ext-pecl-r3

USE_PHP="php5-6"

DESCRIPTION="PHP bindings for the libssh2 library"
LICENSE="PHP-3.01"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"
DEPEND=">=net-libs/libssh2-1.2"
RDEPEND="${DEPEND}"
PHP_EXT_ECONF_ARGS=""
PDEPEND="php_targets_php7-0? ( dev-php/pecl-ssh2:7 )"

src_prepare(){
	if use php_targets_php5-6 ; then
		php-ext-source-r3_src_prepare
	else
		default_src_prepare
	fi
}
