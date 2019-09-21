# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PHP_EXT_NAME="mongodb"
USE_PHP="php5-6 php7-1 php7-2 php7-3"

inherit php-ext-pecl-r3

DESCRIPTION="MongoDB database driver for PHP"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl sasl"

COMMON_DEPEND="
	php_targets_php5-6? ( dev-lang/php:5.6[json,ssl,zlib] )
	php_targets_php7-1? ( dev-lang/php:7.1[json,ssl,zlib] )
	php_targets_php7-2? ( dev-lang/php:7.2[json,ssl,zlib] )
	php_targets_php7-3? ( dev-lang/php:7.3[json,ssl,zlib] )"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/libbson-1.13.0
	>=dev-libs/mongo-c-driver-1.13.0[sasl?,ssl]
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	sasl? ( dev-libs/cyrus-sasl )"
RDEPEND="${DEPEND}"
BDEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"

src_configure() {
	local PHP_EXT_ECONF_ARGS=(
		--enable-mongodb
		--with-libbson
		--with-libmongoc
		--with-mongodb-sasl=$(usex sasl)
	)
	php-ext-source-r3_src_configure
}
