# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

USE_PHP="php5-6 php7-0"

inherit php-ext-pecl-r3

DESCRIPTION="An extension to track progress of a file upload"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

for target in ${USE_PHP}; do
	slot=${target/php}
	slot=${slot/-/.}
	PHPUSEDEPEND="${PHPUSEDEPEND}
	php_targets_${target}? ( dev-lang/php:${slot}[apache2] )"
done

RDEPEND="${PHPUSEDEPEND}"
PATCHES=( "${FILESDIR}/1.0.3.1-php7.patch" )
PHP_EXT_ECONF_ARGS=()

pkg_postinst() {
	elog "This extension is only known to work on Apache with mod_php."
}
