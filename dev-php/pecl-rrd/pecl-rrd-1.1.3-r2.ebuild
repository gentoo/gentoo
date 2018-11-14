# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_PHP="php5-6 php7-0 php7-1"

inherit php-ext-pecl-r3

USE_PHP="php5-6"

DESCRIPTION="RRDtool bindings for PHP"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="php_targets_php5-6? ( net-analyzer/rrdtool[graph] )"
RDEPEND="${DEPEND}"

PDEPEND="
	php_targets_php7-0? ( dev-php/pecl-rrd:7[php_targets_php7-0(-)] )
	php_targets_php7-1? ( dev-php/pecl-rrd:7[php_targets_php7-1(-)] )
"

src_prepare() {
	if use php_targets_php5-6 ; then
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
	if use php_targets_php5-6 ; then
		php-ext-pecl-r3_src_install
	fi
}
