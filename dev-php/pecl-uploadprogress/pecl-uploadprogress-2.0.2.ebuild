# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_PHP="php7-3 php7-4 php8-0"
PHP_EXT_SAPIS="apache2 fpm"

inherit php-ext-pecl-r3

DESCRIPTION="An extension to track progress of a file upload"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="
	php_targets_php7-3? ( || ( dev-lang/php:7.3[apache2(-),fileinfo(-)] dev-lang/php:7.3[fileinfo(-),fpm(-)] ) )
	php_targets_php7-4? ( || ( dev-lang/php:7.4[apache2(-),fileinfo(-)] dev-lang/php:7.4[fileinfo(-),fpm(-)] ) )
	php_targets_php8-0? ( || ( dev-lang/php:8.0[apache2(-),fileinfo(-)] dev-lang/php:8.0[fileinfo(-),fpm(-)] ) )
"
