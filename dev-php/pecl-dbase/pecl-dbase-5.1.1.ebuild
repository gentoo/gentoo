# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_PHP="php5-6 php7-0 php7-1"

inherit php-ext-pecl-r3

USE_PHP="php5-6"

KEYWORDS="~amd64 ~x86"

DESCRIPTION="dBase database file access functions"
LICENSE="PHP-3.01"
SLOT="0"
IUSE=""

DEPEND=""
PDEPEND="
php_targets_php7-0? ( dev-php/pecl-dbase:7[php_targets_php7-0] )
php_targets_php7-1? ( dev-php/pecl-dbase:7[php_targets_php7-1] )
"

src_prepare() {
	if use php_targets_php5-6 ; then
		php-ext-source-r3_src_prepare
	else
		eapply_user
	fi
}

src_configure() {
	if use php_targets_php5-6 ; then
		local PHP_EXT_ECONF_ARGS=( )
		php-ext-source-r3_src_configure
	fi
}

src_install() {
	if use php_targets_php5-6 ; then
		php-ext-pecl-r3_src_install
	fi
}
