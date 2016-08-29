# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PHP_EXT_NAME="mysqlnd_qc"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php5-5 php5-6"

inherit php-ext-pecl-r3 flag-o-matic

KEYWORDS="~amd64"

DESCRIPTION="A query cache plugin for the mysqlnd library"
LICENSE="PHP-3"
SLOT="0"
IUSE="memcached sqlite"

# Specifying targets due to USE flag transition
DEPEND="
	memcached? ( dev-libs/libmemcached )
	sqlite? ( dev-db/sqlite:3 )
	php_targets_php5-5? ( || (
				 dev-lang/php:5.5[-libmysqlclient,mysql]
				 dev-lang/php:5.5[-libmysqlclient,mysqli]
				)
			    )
	php_targets_php5-6? ( || (
				 dev-lang/php:5.6[-libmysqlclient,mysql]
				 dev-lang/php:5.6[-libmysqlclient,mysqli]
				)
			    )
"
RDEPEND="${DEPEND}"
PATCHES=( "${FILESDIR}/${P}-php56.patch" )

src_configure() {
	local PHP_EXT_ECONF_ARGS=()
	if use memcached ; then
		# configure does not find pthreads when memcache is enabled
		append-flags -pthread
		PHP_EXT_ECONF_ARGS+=( --enable-mysqlnd_qc_memcache --with-libmemcached-dir="${ROOT}usr" )
	else
		PHP_EXT_ECONF_ARGS+=( --disable-mysqlnd_qc_memcache )
	fi
	if use sqlite ; then
		PHP_EXT_ECONF_ARGS+=( --enable-mysqlnd_qc_sqlite --with-sqlite-dir="${ROOT}usr" )
	else
		PHP_EXT_ECONF_ARGS+=( --disable-mysqlnd_qc_sqlite )
	fi
	php-ext-source-r3_src_configure
}
