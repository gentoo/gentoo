# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PHP_EXT_NAME="mailparse"
PHP_EXT_ECONF_ARGS=""
DOCS=( README )

USE_PHP="php5-6 php7-0 php7-1"

inherit php-ext-pecl-r3

USE_PHP="php5-6"
KEYWORDS="amd64 ~ppc ~ppc64 x86"

DESCRIPTION="PHP extension for parsing RFC822 and RFC2045 (MIME) messages"
LICENSE="PHP-2.02"
SLOT="0"
IUSE=""

RDEPEND="php_targets_php5-6? ( dev-lang/php:5.6[unicode] )"
DEPEND="${RDEPEND}
	dev-util/re2c"
PDEPEND="
php_targets_php7-0? ( dev-php/pecl-mailparse:7[php_targets_php7-0] )
php_targets_php7-1? ( dev-php/pecl-mailparse:7[php_targets_php7-1] )
"

src_prepare() {
	if use php_targets_php5-6 ; then
		php-ext-source-r3_src_prepare
	else
		eapply_user
	fi
}

src_install() {
	if use php_targets_php5-6 ; then
		php-ext-pecl-r3_src_install
	fi
}
