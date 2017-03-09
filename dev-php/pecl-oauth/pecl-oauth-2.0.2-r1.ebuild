# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PHP_EXT_NAME="oauth"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php5-6 php7-0 php7-1"

inherit php-ext-pecl-r3

# Really only build for 7.0
USE_PHP="php7-0 php7-1"

KEYWORDS="~amd64 ~x86"

DESCRIPTION="OAuth is an authorization protocol built on top of HTTP"
LICENSE="BSD"
SLOT="7"
IUSE="+curl examples"

DEPEND="php_targets_php7-0? ( dev-lang/php:7.0[hash]
		dev-libs/libpcre:3= curl? ( net-misc/curl:0= ) )
	php_targets_php7-1? ( dev-lang/php:7.1[hash]
		dev-libs/libpcre:3= curl? ( net-misc/curl:0= ) )
"
RDEPEND="${DEPEND} php_targets_php5-6? ( ${CATEGORY}/${PN}:0[php_targets_php5-6(-)?] )"

src_prepare() {
	if use php_targets_php7-0 || use php_targets_php7-1 ; then
		local PATCHES=( "${FILESDIR}/${PV}-compare_segfault.patch" )
		php-ext-source-r3_src_prepare
	else
		eapply_user
	fi
}

src_configure() {
	if use php_targets_php7-0 || use php_targets_php7-1 ; then
		local PHP_EXT_ECONF_ARGS=(
			--enable-oauth
			$(use_with curl)
		)

		php-ext-source-r3_src_configure
	fi
}

src_install() {
	if use php_targets_php7-0 || use php_targets_php7-1 ; then
		php-ext-pecl-r3_src_install
	fi
}
