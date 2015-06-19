# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/pecl-translit/pecl-translit-0.6.1-r1.ebuild,v 1.1 2014/09/30 23:59:36 grknight Exp $

EAPI=5

PHP_EXT_NAME="translit"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php5-6 php5-5 php5-4"

inherit php-ext-pecl-r2

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Transliterates non-latin character sets to latin"
LICENSE="PHP-3"
SLOT="0"
IUSE=""
