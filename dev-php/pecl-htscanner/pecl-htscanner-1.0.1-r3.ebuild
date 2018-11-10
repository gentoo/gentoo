# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PHP_EXT_NAME="htscanner"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="README"
PHP_EXT_SAPIS="cgi"

USE_PHP="php5-6"

inherit php-ext-pecl-r3

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Enables .htaccess options for php-scripts running as cgi"
LICENSE="PHP-3"
SLOT="0"
IUSE=""

for target in ${USE_PHP}; do
	slot=${target/php}
	slot=${slot/-/.}
	PHPUSEDEPEND="${PHPUSEDEPEND}
	php_targets_${target}? ( dev-lang/php:${slot}[cgi] )"
done

DEPEND="${PHPUSEDEPEND}"
RDEPEND="${DEPEND}"

src_install() {
	php-ext-pecl-r3_src_install

	php-ext-source-r3_addtoinifiles "config_file" ".htaccess"
	php-ext-source-r3_addtoinifiles "default_docroot" "/"
	php-ext-source-r3_addtoinifiles "default_ttl" "300"
	php-ext-source-r3_addtoinifiles "stop_on_error" "0"
}
