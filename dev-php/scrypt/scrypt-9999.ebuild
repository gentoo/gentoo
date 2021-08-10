# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PHP_EXT_ECONF_ARGS="--enable-scrypt"
USE_PHP="php7-3 php7-4 php8-0"
EGIT_REPO_URI="https://github.com/DomBlack/php-scrypt.git"

inherit git-r3 php-ext-pecl-r3

DESCRIPTION="A PHP wrapper fo the scrypt hashing algorithm"
SRC_URI=""

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-util/re2c"
