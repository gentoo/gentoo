# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WANT_AUTOMAKE="none"
PHP_EXT_NAME="mailparse"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
PHP_EXT_ECONF_ARGS=""
USE_PHP="php7-1 php7-2 php7-3 php7-4"
PHP_EXT_NEEDED_USE="unicode"
DOCS=( README.md )

inherit php-ext-pecl-r3

KEYWORDS="amd64 ppc ppc64 ~x86"

DESCRIPTION="PHP extension for parsing and working with RFC822 and MIME compliant messages"
LICENSE="PHP-3.01"
SLOT="7"
IUSE=""

src_prepare() {
	# Missing test source files in archive.  Fixed upstream in next release.
	rm tests/011.phpt tests/bug001.phpt || die
	php-ext-source-r3_src_prepare
}
