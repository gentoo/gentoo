# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PHP_EXT_NAME="oauth"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php5-6 php7-0 php7-1 php7-2 php7-3 php7-4"

inherit php-ext-pecl-r3

# Really only build for 7.0
USE_PHP="php7-0 php7-1 php7-2 php7-3 php7-4"

KEYWORDS="~amd64 ~x86"

DESCRIPTION="OAuth is an authorization protocol built on top of HTTP"
LICENSE="BSD"
SLOT="7"
IUSE="+curl examples"

DEPEND="php_targets_php7-0? ( dev-lang/php:7.0[hash]
		dev-libs/libpcre:3= curl? ( net-misc/curl:0= ) )
	php_targets_php7-1? ( dev-lang/php:7.1[hash]
		dev-libs/libpcre:3= curl? ( net-misc/curl:0= ) )
	php_targets_php7-2? ( dev-lang/php:7.2[hash]
		dev-libs/libpcre:3= curl? ( net-misc/curl:0= ) )
	php_targets_php7-3? ( dev-lang/php:7.3[hash]
		dev-libs/libpcre:3= curl? ( net-misc/curl:0= ) )
	php_targets_php7-4? (
		dev-libs/libpcre:3= curl? ( net-misc/curl:0= ) )
"
RDEPEND="${DEPEND} php_targets_php5-6? ( ${CATEGORY}/${PN}:0[php_targets_php5-6(-)?] )"

src_prepare() {
	if use php_targets_php7-0 || use php_targets_php7-1 || use php_targets_php7-2 || use php_targets_php7-3 || use php_targets_php7-4; then
		# Disable tests that depend on header order
		rm "${S}/tests/bug16946.phpt" "${S}/tests/overflow_redir.phpt" || die
		php-ext-source-r3_src_prepare
	else
		eapply_user
	fi
}

src_configure() {
	if use php_targets_php7-0 || use php_targets_php7-1 || use php_targets_php7-2 || use php_targets_php7-3 || use php_targets_php7-4; then
		local PHP_EXT_ECONF_ARGS=(
			--enable-oauth
			$(use_with curl)
		)

		php-ext-source-r3_src_configure
	fi
}

src_install() {
	if use php_targets_php7-0 || use php_targets_php7-1 || use php_targets_php7-2 || use php_targets_php7-3 || use php_targets_php7-4; then
		php-ext-pecl-r3_src_install
	fi
}
