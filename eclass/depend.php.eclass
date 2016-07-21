# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @DEAD
# @ECLASS: depend.php.eclass
# @MAINTAINER:
# Gentoo PHP team <php-bugs@gentoo.org>
# @AUTHOR:
# Author: Stuart Herbert <stuart@gentoo.org>
# Author: Luca Longinotti <chtekk@gentoo.org>
# Author: Jakub Moc <jakub@gentoo.org> (documentation)
# @BLURB: Functions to allow ebuilds to depend on php5 and check for specific features.
# @DESCRIPTION:
# This eclass provides functions that allow ebuilds to depend on php5 and check
# for specific PHP features, SAPIs etc. Also provides dodoc-php wrapper to install
# documentation for PHP packages to php-specific location.
# This eclass is deprecated and is set to be removed 30 days after bug 552836 is resolved

inherit eutils multilib

# PHP5-only depend functions

# @FUNCTION: need_php5
# @DESCRIPTION:
# Set this after setting DEPEND/RDEPEND in your ebuild if the ebuild requires PHP5
# (with any SAPI).
need_php5() {
	DEPEND="${DEPEND} =dev-lang/php-5*"
	RDEPEND="${RDEPEND} =dev-lang/php-5*"
	PHP_VERSION="5"
	PHP_SHARED_CAT="php5"
}

# common settings go in here
uses_php5() {
	# cache this
	libdir=$(get_libdir)

	PHPIZE="/usr/${libdir}/php5/bin/phpize"
	PHPCONFIG="/usr/${libdir}/php5/bin/php-config"
	PHPCLI="/usr/${libdir}/php5/bin/php"
	PHPCGI="/usr/${libdir}/php5/bin/php-cgi"
	PHP_PKG="$(best_version =dev-lang/php-5*)"
	PHPPREFIX="/usr/${libdir}/php5"
	EXT_DIR="$(${PHPCONFIG} --extension-dir 2>/dev/null)"

	einfo
	einfo "Using ${PHP_PKG}"
	einfo
}

# general PHP depend functions

# @FUNCTION: need_php_httpd
# @DESCRIPTION:
# Set this after setting DEPEND/RDEPEND in your ebuild if the ebuild requires PHP
# (any version) with either cgi or apache2 SAPI.
need_php_httpd() {
	DEPEND="${DEPEND} virtual/httpd-php"
	RDEPEND="${RDEPEND} virtual/httpd-php"
}

# @FUNCTION: need_php
# @DESCRIPTION:
# Set this after setting DEPEND/RDEPEND in your ebuild if the ebuild requires PHP
# (any version with any SAPI).
need_php() {
	DEPEND="${DEPEND} dev-lang/php"
	RDEPEND="${RDEPEND} dev-lang/php"
	PHP_SHARED_CAT="php"
}

# @FUNCTION: has_php
# @DESCRIPTION:
# Call this function from your pkg_setup, src_compile, src_install etc. if you
# need to know which PHP version is being used and where the PHP binaries/data
# are installed.
has_php() {
	# Detect which PHP version we have installed
	if has_version '=dev-lang/php-5*' ; then
		PHP_VERSION="5"
	else
		die "Unable to find an installed dev-lang/php package"
	fi

	# If we get here, then PHP_VERSION tells us which version of PHP we
	# want to use
	uses_php${PHP_VERSION}
}

# @FUNCTION: require_php_with_use
# @USAGE: <list of USE flags>
# @DESCRIPTION:
# Call this function from pkg_setup if your package requires PHP compiled
# with specific USE flags. Returns if all of the listed USE flags are enabled.
# Dies if any of the listed USE flags are disabled.

# @VARIABLE: PHPCHECKNODIE
# @DESCRIPTION:
# You can set PHPCHECKNODIE to non-empty value in your ebuild to chain multiple
# require_php_with_(any)_use checks without making the ebuild die on every failure.
# This is useful in cases when certain PHP features are only required if specific
# USE flag(s) are enabled for that ebuild.
# @CODE
# Example:
#
# local flags="pcre session snmp sockets wddx"
# use mysql && flags="${flags} mysql"
# use postgres && flags="${flags} postgres"
# if ! PHPCHECKNODIE="yes" require_php_with_use ${flags} \
#	|| ! PHPCHECKNODIE="yes" require_php_with_any_use gd gd-external ; then
#	die "Re-install ${PHP_PKG} with ${flags} and either gd or gd-external"
# fi
# @CODE
require_php_with_use() {
	has_php

	local missing_use=""
	local x

	einfo "Checking for required PHP feature(s) ..."

	for x in $@ ; do
		case $x in
			pcre|spl|reflection|mhash)
				eqawarn "require_php_with_use MUST NOT check for the pcre, spl, mhash or reflection USE flag."
				eqawarn "These USE flags are removed from >=dev-lang/php-5.3 and your ebuild will break"
				eqawarn "if you check the USE flags against PHP 5.3 ebuilds."
				eqawarn "Please use USE dependencies from EAPI 2 instead"
				;;
		esac

		if ! built_with_use =${PHP_PKG} ${x} ; then
			einfo "  Discovered missing USE flag: ${x}"
			missing_use="${missing_use} ${x}"
		fi
	done

	if [[ -z "${missing_use}" ]] ; then
		if [[ -z "${PHPCHECKNODIE}" ]] ; then
			return
		else
			return 0
		fi
	fi

	if [[ -z "${PHPCHECKNODIE}" ]] ; then
		eerror
		eerror "${PHP_PKG} needs to be re-installed with all of the following"
		eerror "USE flags enabled:"
		eerror
		eerror "  $@"
		eerror
		die "Missing PHP USE flags found"
	else
		return 1
	fi
}


# ========================================================================
# require_*() functions
#
# These functions die() if PHP was built without the required features
# ========================================================================

# @FUNCTION: require_php_cgi
# @DESCRIPTION:
# Determines which installed PHP version has the CGI SAPI enabled.
# Useful for anything which needs to run PHP scripts depending on the CGI SAPI.
# @RETURN: die if feature is missing
require_php_cgi() {
	# If PHP_PKG is set, then we have remembered our PHP settings
	# from last time
	if [[ -n ${PHP_PKG} ]] ; then
		return
	fi

	local PHP_PACKAGE_FOUND=""

	if has_version '=dev-lang/php-5*' ; then
		PHP_PACKAGE_FOUND="1"
		pkg="$(best_version '=dev-lang/php-5*')"
		if built_with_use =${pkg} cgi ; then
			PHP_VERSION="5"
		fi
	fi

	if [[ -z ${PHP_PACKAGE_FOUND} ]] ; then
		die "Unable to find an installed dev-lang/php package"
	fi

	if [[ -z ${PHP_VERSION} ]] ; then
		die "No PHP CGI installed. Re-emerge dev-lang/php with USE=cgi."
	fi

	# If we get here, then PHP_VERSION tells us which version of PHP we
	# want to use
	uses_php${PHP_VERSION}
}

# ========================================================================
# Misc functions
#
# These functions provide miscellaneous checks and functionality.
# ========================================================================

# @FUNCTION: dodoc-php
# @USAGE: <list of docs>
# @DESCRIPTION:
# Alternative to dodoc function for use in our PHP eclasses and ebuilds.
# Stored here because depend.php gets always sourced everywhere in the PHP
# ebuilds and eclasses. It simply is dodoc with a changed path to the docs.
# NOTE: No support for docinto is provided!
dodoc-php() {
if [[ $# -lt 1 ]] ; then
	echo "$0: at least one argument needed" 1>&2
	exit 1
fi

phpdocdir="/usr/share/doc/${CATEGORY}/${PF}/"

for x in $@ ; do
	if [[ -s "${x}" ]] ; then
		insinto "${phpdocdir}"
		doins "${x}"
		gzip -f -9 "${D}/${phpdocdir}/${x##*/}"
	elif [[ ! -e "${x}" ]] ; then
		echo "dodoc-php: ${x} does not exist" 1>&2
	fi
done
}

# @FUNCTION: dohtml-php
# @USAGE: <list of html docs>
# @DESCRIPTION:
# Alternative to dohtml function for use in our PHP eclasses and ebuilds.
# Stored here because depend.php gets always sourced everywhere in the PHP
# ebuilds and eclasses. It simply is dohtml with a changed path to the docs.
# NOTE: No support for [-a|-A|-p|-x] options is provided!
dohtml-php() {
if [[ $# -lt 1 ]] ; then
	echo "$0: at least one argument needed" 1>&2
	exit 1
fi

phphtmldir="/usr/share/doc/${CATEGORY}/${PF}/html"

for x in $@ ; do
	if [[ -s "${x}" ]] ; then
		insinto "${phphtmldir}"
		doins "${x}"
	elif [[ ! -e "${x}" ]] ; then
		echo "dohtml-php: ${x} does not exist" 1>&2
	fi
done
}
