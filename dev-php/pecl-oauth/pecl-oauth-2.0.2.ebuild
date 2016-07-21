# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PHP_EXT_NAME="oauth"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php5-6 php7-0"

inherit php-ext-pecl-r2

# Really only build for 7.0
USE_PHP="php7-0"

KEYWORDS="~amd64 ~x86"

DESCRIPTION="OAuth is an authorization protocol built on top of HTTP"
LICENSE="BSD"
SLOT="7"
IUSE="examples"

for target in ${USE_PHP}; do
	slot=${target/php}
	slot=${slot/-/.}
	PHPUSEDEPEND="${PHPUSEDEPEND}
	php_targets_${target}? ( dev-lang/php:${slot}[hash] )"
done

DEPEND="${PHPUSEDEPEND}"
RDEPEND="${DEPEND} php_targets_php5-6? ( ${CATEGORY}/${PN}:0 )"
