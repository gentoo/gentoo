# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/pecl-spl_types/pecl-spl_types-0.4.0-r1.ebuild,v 1.1 2014/09/30 00:32:06 grknight Exp $

EAPI=5

PHP_EXT_NAME="spl_types"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
PHP_EXT_PECL_PKG="SPL_Types"

USE_PHP="php5-6 php5-5 php5-4"

inherit php-ext-pecl-r2

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Standard PHP library types add-on"
LICENSE="PHP-3"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"
