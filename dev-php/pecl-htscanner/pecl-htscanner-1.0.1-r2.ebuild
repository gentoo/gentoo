# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/pecl-htscanner/pecl-htscanner-1.0.1-r2.ebuild,v 1.1 2015/04/29 01:07:56 grknight Exp $

EAPI=5

PHP_EXT_NAME="htscanner"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="README"
PHPSAPILIST="cgi"

USE_PHP="php5-6 php5-5 php5-4"

inherit php-ext-pecl-r2

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

my_conf="--enable-htscanner"

src_install() {
	php-ext-pecl-r2_src_install

	php-ext-source-r2_addtoinifiles "config_file" ".htaccess"
	php-ext-source-r2_addtoinifiles "default_docroot" "/"
	php-ext-source-r2_addtoinifiles "default_ttl" "300"
	php-ext-source-r2_addtoinifiles "stop_on_error" "0"
}
