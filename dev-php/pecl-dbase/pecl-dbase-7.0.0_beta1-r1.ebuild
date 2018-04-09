# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Define 5.6 here so we get the USE and REQUIRED_USE from the eclass
# This allows us to depend on the other slot
USE_PHP="php5-6 php7-0 php7-1 php7-2"

inherit php-ext-pecl-r3

# However, we only really build for 7.x; so redefine it here
USE_PHP="php7-0 php7-1 php7-2"

KEYWORDS="~amd64 ~x86"

DESCRIPTION="dBase database file access functions"
LICENSE="PHP-3.01"
SLOT="7"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND} php_targets_php5-6? ( dev-php/pecl-dbase:0[php_targets_php5-6] )"

src_prepare() {
	if use php_targets_php7-0 || use php_targets_php7-1 || use php_targets_php7-2 ; then
		php-ext-source-r3_src_prepare
	else
		eapply_user
	fi
}

src_configure() {
	if use php_targets_php7-0 || use php_targets_php7-1 || use php_targets_php7-2 ; then
		local PHP_EXT_ECONF_ARGS=( )
		php-ext-source-r3_src_configure
	fi
}

src_install() {
	if use php_targets_php7-0 || use php_targets_php7-1 || use php_targets_php7-2 ; then
		php-ext-pecl-r3_src_install
	fi
}
