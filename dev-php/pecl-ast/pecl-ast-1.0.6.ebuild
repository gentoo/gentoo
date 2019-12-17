# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_PHP="php7-2 php7-3 php7-4"
inherit php-ext-pecl-r3

DESCRIPTION="Extension exposing PHP 7 abstract syntax tree"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
DEPEND="dev-lang/php"

DOCS=( README.md )
