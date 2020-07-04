# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

# Define 5.6 here so we get the USE and REQUIRED_USE from the eclass
# This allows us to depend on the other slot
USE_PHP="php5-6 php7-0 php7-1 php7-2 php7-3 php7-4"

inherit php-ext-pecl-r3

# However, we only really build for 7.x; so redefine it here
USE_PHP="php7-0 php7-1 php7-2 php7-3 php7-4"

KEYWORDS="~amd64 ~x86"

DESCRIPTION="dBase database file access functions"
LICENSE="PHP-3.01"
SLOT="7"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND} php_targets_php5-6? ( dev-php/pecl-dbase:0[php_targets_php5-6] )"

src_prepare() {
	if use php_targets_php7-0 || use php_targets_php7-1 || use php_targets_php7-2 || use php_targets_php7-3 || use php_targets_php7-4 ; then
		php-ext-source-r3_src_prepare
	else
		eapply_user
	fi
}

src_configure() {
	if use php_targets_php7-0 || use php_targets_php7-1 || use php_targets_php7-2 || use php_targets_php7-3 || use php_targets_php7-4 ; then
		local PHP_EXT_ECONF_ARGS=( )
		php-ext-source-r3_src_configure
	fi
}

src_install() {
	if use php_targets_php7-0 || use php_targets_php7-1 || use php_targets_php7-2 || use php_targets_php7-3 || use php_targets_php7-4 ; then
		php-ext-pecl-r3_src_install
	fi
}
