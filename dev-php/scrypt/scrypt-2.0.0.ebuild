# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PHP_EXT_ECONF_ARGS="--enable-scrypt"
USE_PHP="php8-1 php8-2"

inherit php-ext-pecl-r3

DESCRIPTION="A PHP wrapper for the scrypt hashing algorithm"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-util/re2c"
