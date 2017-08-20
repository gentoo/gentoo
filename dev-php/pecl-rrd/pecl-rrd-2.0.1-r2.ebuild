# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Define 5.6 here to have the {,REQUIRED_}USE generated
USE_PHP="php5-6 php7-0 php7-1"

inherit php-ext-pecl-r3

# But we really only build 7.0
USE_PHP="php7-0 php7-1"

DESCRIPTION="RRDtool bindings for PHP"
LICENSE="BSD"
SLOT="7"
KEYWORDS="~amd64 ~x86"

DEPEND="
	php_targets_php7-0? ( net-analyzer/rrdtool[graph] )
	php_targets_php7-1? ( net-analyzer/rrdtool[graph] )
"
RDEPEND="${DEPEND} php_targets_php5-6? ( ${CATEGORY}/${PN}:0 )"

src_prepare() {
	if use php_targets_php7-0 || use php_targets_php7-1 ; then
		php-ext-source-r3_src_prepare
	else
		default_src_prepare
	fi
}

src_configure() {
	local PHP_EXT_ECONF_ARGS=()
	php-ext-source-r3_src_configure
}

src_install() {
	if use php_targets_php7-0 || use php_targets_php7-1 ; then
		php-ext-pecl-r3_src_install
	fi
}
