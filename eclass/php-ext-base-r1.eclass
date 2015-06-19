# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/php-ext-base-r1.eclass,v 1.18 2015/06/17 19:23:34 grknight Exp $

# @ECLASS: php-ext-base-r1.eclass
# @MAINTAINER:
# Gentoo PHP team <php-bugs@gentoo.org>
# @AUTHOR:
# Author: Tal Peer <coredumb@gentoo.org>
# Author: Stuart Herbert <stuart@gentoo.org>
# Author: Luca Longinotti <chtekk@gentoo.org>
# Author: Jakub Moc <jakub@gentoo.org> (documentation)
# @BLURB: A unified interface for adding standalone PHP extensions.
# @DESCRIPTION:
# This eclass provides a unified interface for adding standalone
# PHP extensions (modules) to the php.ini files on your system.
#
# Combined with php-ext-source-r1, we have a standardised solution for supporting
# PHP extensions.
# This eclass is no longer in use and scheduled to be removed on 2015-07-17
# @DEAD

# Block ebuilds with minor version slotting. Quite temporary fix
DEPEND="!=dev-lang/php-5.3.3-r2
		!=dev-lang/php-5.2.14-r1
		!=dev-lang/php-5.3.3-r3
		!=dev-lang/php-5.3.5
		!=dev-lang/php-5.3.4-r1
		!=dev-lang/php-5.3.4
		!=dev-lang/php-5.2.16
		!=dev-lang/php-5.2.17
		!=dev-lang/php-5.2.14-r2"

inherit depend.php

EXPORT_FUNCTIONS src_install

# @ECLASS-VARIABLE: PHP_EXT_NAME
# @DESCRIPTION:
# The extension name. This must be set, otherwise the eclass dies.
# Only automagically set by php-ext-pecl-r1.eclass, so unless your ebuild
# inherits that eclass, you must set this manually before inherit.
[[ -z "${PHP_EXT_NAME}" ]] && die "No module name specified for the php-ext-base-r1 eclass"

# @ECLASS-VARIABLE: PHP_EXT_INI
# @DESCRIPTION:
# Controls whether or not to add a line to php.ini for the extension.
# Defaults to "yes" and should not be changed in most cases.
[[ -z "${PHP_EXT_INI}" ]] && PHP_EXT_INI="yes"

# @ECLASS-VARIABLE: PHP_EXT_ZENDEXT
# @DESCRIPTION:
# Controls whether the extension is a ZendEngine extension or not.
# Defaults to "no" and if you don't know what is it, you don't need it.
[[ -z "${PHP_EXT_ZENDEXT}" ]] && PHP_EXT_ZENDEXT="no"


php-ext-base-r1_buildinilist() {
	# Work out the list of <ext>.ini files to edit/add to
	if [[ -z "${PHPSAPILIST}" ]] ; then
		PHPSAPILIST="apache2 cli cgi fpm"
	fi

	PHPINIFILELIST=""

	for x in ${PHPSAPILIST} ; do
		if [[ -f "/etc/php/${x}-php${PHP_VERSION}/php.ini" ]] ; then
			PHPINIFILELIST="${PHPINIFILELIST} etc/php/${x}-php${PHP_VERSION}/ext/${PHP_EXT_NAME}.ini"
		fi
	done
}

# @FUNCTION: php-ext-base-r1_src_install
# @DESCRIPTION:
# Takes care of standard install for PHP extensions (modules).
php-ext-base-r1_src_install() {
	# Pull in the PHP settings
	has_php
	addpredict /usr/share/snmp/mibs/.index

	# Build the list of <ext>.ini files to edit/add to
	php-ext-base-r1_buildinilist

	# Add the needed lines to the <ext>.ini files
	if [[ "${PHP_EXT_INI}" = "yes" ]] ; then
		php-ext-base-r1_addextension "${PHP_EXT_NAME}.so"
	fi

	# Symlink the <ext>.ini files from ext/ to ext-active/
	for inifile in ${PHPINIFILELIST} ; do
		inidir="${inifile/${PHP_EXT_NAME}.ini/}"
		inidir="${inidir/ext/ext-active}"
		dodir "/${inidir}"
		dosym "/${inifile}" "/${inifile/ext/ext-active}"
	done

	# Add support for installing PHP files into a version dependant directory
	PHP_EXT_SHARED_DIR="/usr/share/${PHP_SHARED_CAT}/${PHP_EXT_NAME}"
}

php-ext-base-r1_addextension() {
	if [[ "${PHP_EXT_ZENDEXT}" = "yes" ]] ; then
		# We need the full path for ZendEngine extensions
		# and we need to check for debugging enabled!
		if has_zts ; then
			if has_debug ; then
				ext_type="zend_extension_debug_ts"
			else
				ext_type="zend_extension_ts"
			fi
			ext_file="${EXT_DIR}/$1"
		else
			if has_debug ; then
				ext_type="zend_extension_debug"
			else
				ext_type="zend_extension"
			fi
			ext_file="${EXT_DIR}/$1"
		fi

		# php-5.3 unifies zend_extension loading and just requires the
		# zend_extension keyword with no suffix
		# TODO: drop previous code and this check once <php-5.3 support is
		# discontinued
		if has_version '>=dev-lang/php-5.3' ; then
			ext_type="zend_extension"
		fi
	else
		# We don't need the full path for normal extensions!
		ext_type="extension"
		ext_file="$1"
	fi

	php-ext-base-r1_addtoinifiles "${ext_type}" "${ext_file}" "Extension added"
}

# $1 - Setting name
# $2 - Setting value
# $3 - File to add to
# $4 - Sanitized text to output
php-ext-base-r1_addtoinifile() {
	if [[ ! -d $(dirname $3) ]] ; then
		mkdir -p $(dirname $3)
	fi

	# Are we adding the name of a section?
	if [[ ${1:0:1} == "[" ]] ; then
		echo "$1" >> "$3"
		my_added="$1"
	else
		echo "$1=$2" >> "$3"
		my_added="$1=$2"
	fi

	if [[ -z "$4" ]] ; then
		einfo "Added '$my_added' to /$3"
	else
		einfo "$4 to /$3"
	fi

	insinto /$(dirname $3)
	doins "$3"
}

# @FUNCTION: php-ext-base-r1_addtoinifiles
# @USAGE: <setting name> <setting value> [message to output]; or just [section name]
# @DESCRIPTION:
# Add value settings to php.ini file installed by the extension (module).
# You can also add a [section], see examples below.
#
# @CODE
# Add some settings for the extension:
#
# php-ext-base-r1_addtoinifiles "zend_optimizer.optimization_level" "15"
# php-ext-base-r1_addtoinifiles "zend_optimizer.enable_loader" "0"
# php-ext-base-r1_addtoinifiles "zend_optimizer.disable_licensing" "0"
#
# Adding values to a section in php.ini file installed by the extension:
#
# php-ext-base-r1_addtoinifiles "[Debugger]"
# php-ext-base-r1_addtoinifiles "debugger.enabled" "on"
# php-ext-base-r1_addtoinifiles "debugger.profiler_enabled" "on"
# @CODE
php-ext-base-r1_addtoinifiles() {
	for x in ${PHPINIFILELIST} ; do
		php-ext-base-r1_addtoinifile "$1" "$2" "$x" "$3"
	done
}
