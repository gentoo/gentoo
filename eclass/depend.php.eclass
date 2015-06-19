# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/depend.php.eclass,v 1.35 2015/06/18 14:22:59 grknight Exp $

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

inherit eutils multilib

# PHP5-only depend functions

# @FUNCTION: need_php5_cli
# @DESCRIPTION:
# Set this after setting DEPEND/RDEPEND in your ebuild if the ebuild requires PHP5
# with cli SAPI.
need_php5_cli() {
	eqawarn "(need_php5_cli) Deprecated function call.  Set to be removed on 2015-07-17"
	DEPEND="${DEPEND} =dev-lang/php-5*"
	RDEPEND="${RDEPEND} =dev-lang/php-5*"
	PHP_VERSION="5"
}

# @FUNCTION: need_php5_httpd
# @DESCRIPTION:
# Set this after setting DEPEND/RDEPEND in your ebuild if the ebuild requires PHP5
# with either cgi or apache2 SAPI.
need_php5_httpd() {
	eqawarn "(need_php5_httpd) Deprecated function call.  Set to be removed on 2015-07-17"
	DEPEND="${DEPEND} =virtual/httpd-php-5*"
	RDEPEND="${RDEPEND} =virtual/httpd-php-5*"
	PHP_VERSION="5"
}

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

# @FUNCTION: need_php_cli
# @DESCRIPTION:
# Set this after setting DEPEND/RDEPEND in your ebuild if the ebuild requires PHP
# (any version) with cli SAPI.
need_php_cli() {
	eqawarn "(need_php_cli) Deprecated function call.  Set to be removed on 2015-07-17"
	DEPEND="${DEPEND} dev-lang/php"
	RDEPEND="${RDEPEND} dev-lang/php"
}

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

# @FUNCTION: need_php_by_category
# @DESCRIPTION:
# Set this after setting DEPEND/RDEPEND in your ebuild to depend on PHP version
# determined by ${CATEGORY} - any PHP version or PHP5 for dev-php or
# dev-php5, respectively.
need_php_by_category() {
	eqawarn "(need_php_by_category) Deprecated function call.  Set to be removed on 2015-07-17"
	case "${CATEGORY}" in
		dev-php) need_php ;;
		*) die "Version of PHP required by packages in category ${CATEGORY} unknown"
	esac
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

# @FUNCTION: require_php_sapi_from
# @USAGE: <list of SAPIs>
# @DESCRIPTION:
# Call this function from pkg_setup if your package only works with
# specific SAPI(s) and specify a list of PHP SAPI USE flags that are
# required (one or more from cli, cgi, apache2) as arguments.
# Returns if any of the listed SAPIs have been installed, dies if none
# of them is available.
#
# Unfortunately, if you want to be really sure that the required SAPI is
# provided by PHP, you will have to use this function or similar ones (like
# require_php_cli or require_php_cgi) in pkg_setup until we are able to
# depend on USE flags being enabled. The above described need_php[45]_cli
# and need_php[45]_httpd functions cannot guarantee these requirements.
# See Bug 2272 for details.
require_php_sapi_from() {
	eqawarn "(require_php_sapi_from) Deprecated function call.  Set to be removed on 2015-07-17"
	has_php

	local has_sapi="0"
	local x

	einfo "Checking for compatible SAPI(s)"

	for x in $@ ; do
		if built_with_use =${PHP_PKG} ${x} ; then
			einfo "  Discovered compatible SAPI ${x}"
			has_sapi="1"
		fi
	done

	if [[ "${has_sapi}" == "1" ]] ; then
		return
	fi

	eerror
	eerror "${PHP_PKG} needs to be re-installed with one of the following"
	eerror "USE flags enabled:"
	eerror
	eerror "  $@"
	eerror
	die "No compatible PHP SAPIs found"
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

# @FUNCTION: require_php_with_any_use
# @USAGE: <list of USE flags>
# @DESCRIPTION:
# Call this function from pkg_setup if your package requires PHP compiled with
# any of specified USE flags. Returns if any of the listed USE flags are enabled.
# Dies if all of the listed USE flags are disabled.
require_php_with_any_use() {
	eqawarn "(require_php_with_any_use) Deprecated function call.  Set to be removed on 2015-07-17"
	has_php

	local missing_use=""
	local x

	einfo "Checking for required PHP feature(s) ..."

	for x in $@ ; do
		if built_with_use =${PHP_PKG} ${x} ; then
			einfo "  USE flag ${x} is enabled, ok ..."
			return
		else
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
		eerror "${PHP_PKG} needs to be re-installed with any of the following"
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
# has_*() functions
#
# These functions return 0 if the condition is satisfied, 1 otherwise
# ========================================================================

# @FUNCTION: has_zts
# @DESCRIPTION:
# Check if our PHP was compiled with ZTS (Zend Thread Safety) enabled.
# @RETURN: 0 if true, 1 otherwise
has_zts() {
	eqawarn "(has_zts) Deprecated function call.  Set to be removed on 2015-07-17"
	has_php

	if built_with_use =${PHP_PKG} apache2 threads ; then
		return 0
	fi

	return 1
}

# @FUNCTION: has_debug
# @DESCRIPTION:
# Check if our PHP was built with debug support enabled.
# @RETURN: 0 if true, 1 otherwise
has_debug() {
	eqawarn "(has_debug) Deprecated function call.  Set to be removed on 2015-07-17"
	has_php

	if built_with_use =${PHP_PKG} debug ; then
		return 0
	fi

	return 1
}

# @FUNCTION: has_concurrentmodphp
# @DESCRIPTION:
# Check if our PHP was built with the concurrentmodphp support enabled.
# @RETURN: 0 if true, 1 otherwise
has_concurrentmodphp() {
	eqawarn "(has_concurrentmodphp) Deprecated function call.  Set to be removed on 2015-07-17"
	has_php

	if built_with_use =${PHP_PKG} apache2 concurrentmodphp ; then
		return 0
	fi

	return 1
}

# ========================================================================
# require_*() functions
#
# These functions die() if PHP was built without the required features
# ========================================================================

# @FUNCTION: require_pdo
# @DESCRIPTION:
# Require a PHP built with PDO support (PHP5 only).
# This function is now redundant and DEPRECATED since
# pdo-external use flag and pecl-pdo-* ebuilds were removed.
# You should use require_php_with_use pdo instead now.
# @RETURN: die if feature is missing
require_pdo() {
	eqawarn "(require_pdo) Deprecated function call.  Set to be removed on 2015-07-17"
	has_php

	# Was PHP5 compiled with internal PDO support?
	if built_with_use =${PHP_PKG} pdo ; then
		return
	else
		eerror
		eerror "No PDO extension for PHP found."
		eerror "Please note that PDO only exists for PHP 5."
		eerror "Please install a PDO extension for PHP 5."
		eerror "You must install >=dev-lang/php-5.1 with USE=\"pdo\"."
		eerror
		die "No PDO extension for PHP 5 found"
	fi
}

# @FUNCTION: require_php_cli
# @DESCRIPTION:
# Determines which installed PHP version has the CLI SAPI enabled.
# Useful for PEAR stuff, or anything which needs to run PHP script
# depending on the CLI SAPI.
# @RETURN: die if feature is missing
require_php_cli() {
	eqawarn "(require_php_cli) Deprecated function call.  Set to be removed on 2015-07-17"
	# If PHP_PKG is set, then we have remembered our PHP settings
	# from last time
	if [[ -n ${PHP_PKG} ]] ; then
		return
	fi

	local PHP_PACKAGE_FOUND=""

	if has_version '=dev-lang/php-5*' ; then
		PHP_PACKAGE_FOUND="1"
		pkg="$(best_version '=dev-lang/php-5*')"
		if built_with_use =${pkg} cli ; then
			PHP_VERSION="5"
		fi
	fi

	if [[ -z ${PHP_PACKAGE_FOUND} ]] ; then
		die "Unable to find an installed dev-lang/php package"
	fi

	if [[ -z ${PHP_VERSION} ]] ; then
		die "No PHP CLI installed. Re-emerge dev-lang/php with USE=cli."
	fi

	# If we get here, then PHP_VERSION tells us which version of PHP we
	# want to use
	uses_php${PHP_VERSION}
}

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

# @FUNCTION: require_sqlite
# @DESCRIPTION:
# Require a PHP built with SQLite support
# @RETURN: die if feature is missing
require_sqlite() {
	eqawarn "(require_sqlite) Deprecated function call.  Set to be removed on 2015-07-17"
	has_php

	# Has our PHP been built with SQLite support?
	if built_with_use =${PHP_PKG} sqlite ; then
		return
	fi

	# If we get here, then we don't have any SQLite support for PHP installed
	eerror
	eerror "No SQLite extension for PHP found."
	eerror "Please install an SQLite extension for PHP,"
	eerror "this is done best by simply adding the"
	eerror "'sqlite' USE flag when emerging dev-lang/php."
	eerror
	die "No SQLite extension for PHP found"
}

# @FUNCTION: require_gd
# @DESCRIPTION:
# Require a PHP built with GD support
# @RETURN: die if feature is missing
require_gd() {
	eqawarn "(require_gd) Deprecated function call.  Set to be removed on 2015-07-17"
	has_php

	# Do we have the internal GD support installed?
	if built_with_use =${PHP_PKG} gd ; then
		return
	fi

	# Ok, maybe GD was built using the external library support?
	if built_with_use =${PHP_PKG} gd-external ; then
		return
	fi

	# If we get here, then we have no GD support
	eerror
	eerror "No GD support for PHP found."
	eerror "Please install the GD support for PHP,"
	eerror "you must install dev-lang/php with either"
	eerror "the 'gd' or the 'gd-external' USE flags"
	eerror "turned on."
	eerror
	die "No GD support found for PHP"
}

# ========================================================================
# Misc functions
#
# These functions provide miscellaneous checks and functionality.
# ========================================================================

# @FUNCTION: php_binary_extension
# @DESCRIPTION:
# Executes some checks needed when installing a binary PHP extension.
php_binary_extension() {
	eqawarn "(php_binary_extension) Deprecated function call.  Set to be removed on 2015-07-17"
	has_php

	local PUSE_ENABLED=""

	# Binary extensions do not support the change of PHP
	# API version, so they can't be installed when USE flags
	# are enabled which change the PHP API version, they also
	# don't provide correctly versioned symbols for our use

	if has_debug ; then
		eerror
		eerror "You cannot install binary PHP extensions"
		eerror "when the 'debug' USE flag is enabled!"
		eerror "Please reemerge dev-lang/php with the"
		eerror "'debug' USE flag turned off."
		eerror
		PUSE_ENABLED="1"
	fi

	if has_concurrentmodphp ; then
		eerror
		eerror "You cannot install binary PHP extensions when"
		eerror "the 'concurrentmodphp' USE flag is enabled!"
		eerror "Please reemerge dev-lang/php with the"
		eerror "'concurrentmodphp' USE flag turned off."
		eerror
		PUSE_ENABLED="1"
	fi

	if [[ -n ${PUSE_ENABLED} ]] ; then
		die "'debug' and/or 'concurrentmodphp' USE flags turned on!"
	fi
}

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
