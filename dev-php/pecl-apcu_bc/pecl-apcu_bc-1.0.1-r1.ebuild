# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PHP_EXT_NAME="apc"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="README.md"

USE_PHP="php7-0"

inherit php-ext-pecl-r2

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Provides APC backwards compatibility functions via APCu"
LICENSE="PHP-3.01"
SLOT="0"
IUSE=""

DEPEND="dev-php/pecl-apcu[php_targets_php7-0]"
RDEPEND="${DEPEND}"

src_install() {
	# Refine function to rename the output ini file for this extension
	# to load in the correct order. Bug 572864
	php-ext-source-r2_buildinilist() {
		# Work out the list of <ext>.ini files to edit/add to
		if [[ -z "${PHPSAPILIST}" ]] ; then
			PHPSAPILIST="apache2 cli cgi fpm embed phpdbg"
		fi

		PHPINIFILELIST=""
		local x
		for x in ${PHPSAPILIST} ; do
			if [[ -f "${EPREFIX}/etc/php/${x}-${1}/php.ini" ]] ; then
				PHPINIFILELIST="${PHPINIFILELIST} etc/php/${x}-${1}/ext/bc_apcu.ini"
			fi
		done
		PHPFULLINIFILELIST="${PHPFULLINIFILELIST} ${PHPINIFILELIST}"
	}

	php-ext-pecl-r2_src_install
}
