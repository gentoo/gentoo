# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/pecl-ssh2/pecl-ssh2-0.12-r1.ebuild,v 1.4 2014/10/10 11:06:20 ago Exp $

EAPI=5

PHP_EXT_NAME="ssh2"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="README ChangeLog"

USE_PHP="php5-5 php5-4"

inherit php-ext-pecl-r2

DESCRIPTION="Provides bindings to the functions of libssh2 which implements the SSH2 protocol"
LICENSE="PHP-3"
SLOT="0"
IUSE=""
KEYWORDS="amd64 x86"
DEPEND=">=net-libs/libssh2-1.2"
RDEPEND="${DEPEND}"
