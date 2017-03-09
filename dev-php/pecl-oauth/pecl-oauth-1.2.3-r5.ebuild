# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PHP_EXT_NAME="oauth"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php5-6 php7-0 php7-1"

inherit php-ext-pecl-r3

# Really only build for 5.6
USE_PHP="php5-6"

KEYWORDS="~amd64 ~x86"

DESCRIPTION="OAuth is an authorization protocol built on top of HTTP"
LICENSE="BSD"
SLOT="0"
IUSE="+curl examples"

DEPEND="php_targets_php5-6? ( dev-lang/php:5.6[hash]
		dev-libs/libpcre:3= curl? ( net-misc/curl:0= ) )
"
RDEPEND="${DEPEND} php_targets_php7-0? ( ${CATEGORY}/${PN}:7[php_targets_php7-0(-)?] )
	php_targets_php7-1? ( ${CATEGORY}/${PN}:7[php_targets_php7-1(-)?] )"

src_prepare() {
	if use php_targets_php5-6 ; then
		local PATCHES=(
			"${FILESDIR}/${PV}-withcurl.patch"
			"${FILESDIR}/${PV}-prce.h-check.patch"
		)
		php-ext-source-r3_src_prepare
	else
		eapply_user
	fi
}

src_configure() {
	if use php_targets_php5-6 ; then
		local PHP_EXT_ECONF_ARGS=(
			--enable-oauth
			$(use_with curl)
		)

		php-ext-source-r3_src_configure
	fi
}

src_install() {
	if use php_targets_php5-6 ; then
		php-ext-pecl-r3_src_install
	fi
}
