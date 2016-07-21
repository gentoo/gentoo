# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_PHP="php5-6 php5-5 php5-4"

inherit php-ext-pecl-r2

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

pkg_postinst() {
	elog "This extension is only known to work on Apache with mod_php."
}
