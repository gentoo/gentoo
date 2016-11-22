# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PHP_EXT_NAME="mongodb"
USE_PHP="php5-6 php7-0"
DOCS="README.md"

inherit php-ext-pecl-r2

DESCRIPTION="MongoDB database driver for PHP"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl pcre sasl"

for target in ${USE_PHP}; do
	slot=${target/php}
	slot=${slot/-/.}
	PHPUSEDEPEND="${PHPUSEDEPEND}
	php_targets_${target}? ( dev-lang/php:${slot}[json,ssl,zlib] )"
done
unset target slot
RDEPEND="
	${PHPUSEDEPEND}
	>=dev-libs/libbson-1.3.3
	>=dev-libs/mongo-c-driver-1.3.3[sasl?,ssl]
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	pcre? ( dev-libs/libpcre )
	sasl? ( dev-libs/cyrus-sasl )
"
# pkgconfig needed if system libraries are used for bson and libmongoc
DEPEND="${RDEPEND} virtual/pkgconfig"

src_configure() {
	local my_conf="--enable-mongodb --with-libbson --with-libmongoc "
	my_conf+="--with-pcre-dir=$(usex pcre yes no) --with-mongodb-sasl=$(usex sasl yes no)"
	php-ext-source-r2_src_configure
}
