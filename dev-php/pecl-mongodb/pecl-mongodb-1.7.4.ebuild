# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PHP_EXT_NAME="mongodb"
USE_PHP="php7-2 php7-3 php7-4"

inherit php-ext-pecl-r3

DESCRIPTION="MongoDB database driver for PHP"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="sasl test"

PHP_DEPEND="
	php_targets_php7-2? ( dev-lang/php:7.2[json,ssl,zlib] )
	php_targets_php7-3? ( dev-lang/php:7.3[json,ssl,zlib] )
	php_targets_php7-4? ( dev-lang/php:7.4[json,ssl,zlib] )"
COMMON_DEPEND="${PHP_DEPEND}
	>=dev-libs/libbson-1.16.2
	>=dev-libs/mongo-c-driver-1.16.2[sasl?,ssl]
	dev-libs/openssl:0=
	sasl? ( dev-libs/cyrus-sasl )"
DEPEND="${COMMON_DEPEND}
	test? ( dev-db/mongodb )"
RDEPEND="${COMMON_DEPEND}"
BDEPEND="${PHP_DEPEND}
	virtual/pkgconfig"

# No tests on x86 because tests require dev-db/mongodb which don't support
# x86 anymore (bug #645994)
RESTRICT="x86? ( test )
	!test? ( test )"

src_configure() {
	local PHP_EXT_ECONF_ARGS=(
		--enable-mongodb
		--with-libbson
		--with-libmongoc
		--with-mongodb-sasl=$(usex sasl)
	)
	php-ext-source-r3_src_configure
}

src_test() {
	local PORT=27017
	mongod --port ${PORT} --bind_ip 127.0.0.1 --nounixsocket --fork \
		--dbpath="${T}" --logpath="${T}/mongod.log" || die
	php-ext-pecl-r3_src_test
	kill $(<"${T}/mongod.lock")
}
