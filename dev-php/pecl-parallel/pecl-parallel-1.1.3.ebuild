# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_PHP="php7-2 php7-3 php7-4"
PHP_EXT_SAPIS="cli"
inherit php-ext-pecl-r3

DESCRIPTION="A succinct parallel concurrency API for PHP7"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
DEPEND="dev-lang/php[threads]"
