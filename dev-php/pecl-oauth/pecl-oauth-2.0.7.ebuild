# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PHP_EXT_NAME="oauth"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php7-2 php7-3 php7-4"

inherit php-ext-pecl-r3

KEYWORDS="~amd64 ~x86"

DESCRIPTION="OAuth is an authorization protocol built on top of HTTP"
LICENSE="BSD"
SLOT="7"
IUSE="+curl examples"

DEPEND="php_targets_php7-2? ( dev-lang/php:7.2[hash(-)]
		dev-libs/libpcre:3= curl? ( net-misc/curl:0= ) )
	php_targets_php7-3? ( dev-lang/php:7.3[hash(-)]
		dev-libs/libpcre:3= curl? ( net-misc/curl:0= ) )
	php_targets_php7-4? (
		dev-libs/libpcre:3= curl? ( net-misc/curl:0= ) )
"
RDEPEND="${DEPEND}"

src_configure() {
	local PHP_EXT_ECONF_ARGS=(
		--enable-oauth
		$(use_with curl)
	)
	php-ext-source-r3_src_configure
}
