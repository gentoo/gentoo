# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/pecl-lzf/pecl-lzf-1.6.2-r1.ebuild,v 1.1 2014/09/30 03:03:00 grknight Exp $

EAPI=5

PHP_EXT_NAME="lzf"
PHP_EXT_PECL_PKG="LZF"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
USE_PHP="php5-6 php5-5 php5-4"
DOCS="README ChangeLog"

inherit php-ext-pecl-r2

KEYWORDS="~amd64 ~x86"

DESCRIPTION="This package handles LZF de/compression"
LICENSE="PHP-3"
SLOT="0"
IUSE=""
