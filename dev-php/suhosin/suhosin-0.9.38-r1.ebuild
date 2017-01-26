# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

PHP_EXT_NAME="suhosin"
PHP_EXT_INI="no"
PHP_EXT_ZENDEXT="no"
USE_PHP="php5-6"

inherit php-ext-source-r3

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"

DESCRIPTION="Suhosin is an advanced protection system for PHP installations"
HOMEPAGE="http://www.suhosin.org/"
SRC_URI="http://download.suhosin.org/${P}.tar.gz"
LICENSE="PHP-3.01"
SLOT="0"
IUSE=""

for target in ${USE_PHP}; do
	slot=${target/php}
	slot=${slot/-/.}
	PHPUSEDEPEND="${PHPUSEDEPEND}
	php_targets_${target}? ( dev-lang/php:${slot}[unicode] )"
done

DEPEND="${PHPUSEDEPEND}"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-libcrypt.patch )
DOCS=( CREDITS )

src_install() {
	php-ext-source-r3_src_install

	local slot inifile
	for slot in $(php_get_slots); do
		php_init_slot_env ${slot}
		for inifile in $(php_slot_ini_files "${slot}") ; do
			insinto "${inifile/${PHP_EXT_NAME}.ini/}"
			insopts -m644
			doins "suhosin.ini"
		done
	done
}

src_test() {
	# Makefile passes a hard-coded -d extension_dir=./modules, we move the lib
	# away from there in src_compile
	for slot in `php_get_slots`; do
		php_init_slot_env ${slot}
		NO_INTERACTION="yes" emake test || die "emake test failed for slot ${slot}"
	done
}
