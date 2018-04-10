# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PHP_INI_NAME="bc_apc"
PHP_EXT_NAME="apc"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
PHP_EXT_EXTRA_ECONF=""
DOCS=( README.md )

USE_PHP="php7-0 php7-1 php7-2"

inherit php-ext-pecl-r3

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Provides APC backwards compatibility functions via APCu"
LICENSE="PHP-3.01"
SLOT="0"
IUSE=""

DEPEND="dev-php/pecl-apcu:7[php_targets_php7-0?,php_targets_php7-1?,php_targets_php7-2?]"
RDEPEND="${DEPEND}"
