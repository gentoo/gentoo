# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PHP_EXT_NAME="oauth"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php5-6 php5-5 php5-4"

inherit php-ext-pecl-r2

KEYWORDS="~amd64 ~x86"

DESCRIPTION="OAuth is an authorization protocol built on top of HTTP"
LICENSE="BSD"
SLOT="0"
IUSE="examples"

for target in ${USE_PHP}; do
	slot=${target/php}
	slot=${slot/-/.}
	PHPUSEDEPEND="${PHPUSEDEPEND}
	php_targets_${target}? ( dev-lang/php:${slot}[hash] )"
done

DEPEND="${PHPUSEDEPEND}"
RDEPEND="${DEPEND}"
