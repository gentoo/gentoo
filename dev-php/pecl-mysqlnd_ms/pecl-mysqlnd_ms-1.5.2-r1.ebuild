# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PHP_EXT_NAME="mysqlnd_ms"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

# php5-6 fails to build
USE_PHP="php5-5"

inherit php-ext-pecl-r2

KEYWORDS="~amd64"

DESCRIPTION="A replication and load balancing plugin for the mysqlnd library"
LICENSE="PHP-3"
SLOT="0"
IUSE=""

# Specifying targets due to USE flag transition
DEPEND="
	php_targets_php5-5? ( || (
				 dev-lang/php:5.5[-libmysqlclient,mysql]
				 dev-lang/php:5.5[-libmysqlclient,mysqli]
				)
			)
"
RDEPEND="${DEPEND}"
