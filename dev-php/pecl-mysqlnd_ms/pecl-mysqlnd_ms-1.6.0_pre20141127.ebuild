# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PHP_EXT_NAME="mysqlnd_ms"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php5-5 php5-6"
# This is an SVN snapshot stored locally
SRC_URI="https://dev.gentoo.org/~grknight/distfiles/${P}.tar.xz"
inherit php-ext-source-r3

HOMEPAGE="http://pecl.php.net/package/mysqlnd_ms"
KEYWORDS="~amd64"

DESCRIPTION="A replication and load balancing plugin for the mysqlnd library"
LICENSE="PHP-3"
SLOT="0"
IUSE=""

# Specifying targets due to USE flag transition
DEPEND="
	dev-libs/libxml2
	php_targets_php5-5? ( || (
				 dev-lang/php:5.5[-libmysqlclient,mysql,json]
				 dev-lang/php:5.5[-libmysqlclient,mysqli,json]
				)
			)
	php_targets_php5-6? ( || (
				 dev-lang/php:5.6[-libmysqlclient,mysql,json]
				 dev-lang/php:5.6[-libmysqlclient,mysqli,json]
				)
			)
"
RDEPEND="${DEPEND}"
