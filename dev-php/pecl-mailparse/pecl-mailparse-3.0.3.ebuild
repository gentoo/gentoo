# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PHP_EXT_NAME="mailparse"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
PHP_EXT_ECONF_ARGS=""
DOCS=( README.md )

USE_PHP="php7-0 php7-1 php5-6 php7-2 php7-3"

inherit php-ext-pecl-r3

# Only build for 7.x
USE_PHP="php7-0 php7-1 php7-2 php7-3"

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

DESCRIPTION="PHP extension for parsing and working with RFC822 and MIME compliant messages"
LICENSE="PHP-3.01"
SLOT="7"
IUSE=""

PHPUSEDEPEND="
	php_targets_php7-0? ( dev-lang/php:7.0[unicode] )
	php_targets_php7-1? ( dev-lang/php:7.1[unicode] )
	php_targets_php7-2? ( dev-lang/php:7.2[unicode] )
"
DEPEND="${PHPUSEDEPEND}
	dev-util/re2c"
RDEPEND="${PHPUSEDEPEND} php_targets_php5-6? ( dev-php/pecl-mailparse:0[php_targets_php5-6] )"

src_prepare() {
	if use php_targets_php7-0 || use php_targets_php7-1 || use php_targets_php7-2 ; then
		# Missing test source files in archive.  Fixed upstream in next release.
		rm tests/011.phpt tests/bug001.phpt || die
		php-ext-source-r3_src_prepare
	else
		default
	fi
}

src_install() {
	if use php_targets_php7-0 || use php_targets_php7-1 || use php_targets_php7-2 ; then
		php-ext-pecl-r3_src_install
	fi
}
