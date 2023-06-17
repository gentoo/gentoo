# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PHP_EXT_ECONF_ARGS="--enable-scrypt"
USE_PHP="php8-0 php8-1 php8-2"
EGIT_REPO_URI="https://github.com/DomBlack/php-scrypt.git"

inherit git-r3 php-ext-pecl-r3

DESCRIPTION="A PHP wrapper fo the scrypt hashing algorithm"
SRC_URI=""

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-util/re2c"
