# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_PHP="php5-6 php7-1 php7-2 php7-3"
PHP_EXT_NAME="stomp"
DOCS=( CREDITS doc/classes.php doc/functions.php )

inherit php-ext-pecl-r3

USE_PHP="php5-6"

KEYWORDS="~amd64 ~x86"

DESCRIPTION="PHP extension to communicate with Stomp message brokers"
LICENSE="PHP-3.01"
SLOT="0"
IUSE="examples ssl"

DEPEND="${DEPEND}
	php_targets_php5-6? ( dev-lang/php:5.6[ssl?] )
"

RDEPEND="${DEPEND}"
PDEPEND="
	php_targets_php7-1? ( dev-php/pecl-stomp:7 )
	php_targets_php7-2? ( dev-php/pecl-stomp:7 )
	php_targets_php7-3? ( dev-php/pecl-stomp:7 )
"

src_prepare() {
	if use php_targets_php5-6 ; then
		php-ext-source-r3_src_prepare
	else
		default_src_prepare
	fi
}

src_configure() {
	local PHP_EXT_ECONF_ARGS=(
		--enable-stomp
		--with-openssl-dir=$(usex ssl "${EPREFIX}/usr")
	)
	php-ext-source-r3_src_configure
}

src_install() {
	if use php_targets_php5-6 ; then
		php-ext-pecl-r3_src_install
	fi
}
