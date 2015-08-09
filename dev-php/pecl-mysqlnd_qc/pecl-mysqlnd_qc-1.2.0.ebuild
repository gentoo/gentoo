# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PHP_EXT_NAME="mysqlnd_qc"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

# Fails to build with php5-6
USE_PHP="php5-5 php5-4"

inherit php-ext-pecl-r2 confutils flag-o-matic

KEYWORDS="~amd64"

DESCRIPTION="A query cache plugin for the mysqlnd library"
LICENSE="PHP-3"
SLOT="0"
IUSE="memcached sqlite"

# Specifying targets due to USE flag transition
DEPEND="
	memcached? ( dev-libs/libmemcached )
	sqlite? ( dev-db/sqlite:3 )
	php_targets_php5-4? ( dev-lang/php:5.4[mysqlnd] )
	php_targets_php5-5? ( || (
				 dev-lang/php:5.5[-libmysqlclient,mysql]
				 dev-lang/php:5.5[-libmysqlclient,mysqli]
				)
			    )
"
RDEPEND="${DEPEND}"

src_configure() {
	# configure does not find pthreads when memcache is enabled
	use memcached && append-flags -pthread
	enable_extension_withonly libmemcached-dir memcached 0 "${ROOT}usr"
	enable_extension_enable mysqlnd_qc_memcache memcached
	enable_extension_withonly sqlite-dir sqlite 0 "${ROOT}usr"
	enable_extension_enable mysqlnd_qc_sqlite sqlite
	php-ext-source-r2_src_configure
}
