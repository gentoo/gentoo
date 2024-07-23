# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WANT_AUTOMAKE="none"
PHP_EXT_NAME="mailparse"
USE_PHP="php8-1 php8-2 php8-3"
PHP_EXT_NEEDED_USE="unicode(-)"
DOCS=( README.md )

inherit php-ext-pecl-r3

DESCRIPTION="PHP extension for parsing and working with RFC822 and MIME compliant messages"
LICENSE="PHP-3.01"
SLOT="7"

KEYWORDS="~amd64 ~ppc64 ~x86"
