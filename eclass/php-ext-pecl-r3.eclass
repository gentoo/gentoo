# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: php-ext-pecl-r3.eclass
# @MAINTAINER:
# Gentoo PHP team <php-bugs@gentoo.org>
# @BLURB: A uniform way to install PECL extensions
# @DESCRIPTION:
# This eclass should be used by all dev-php/pecl-* ebuilds as a uniform
# way of installing PECL extensions. For more information about PECL,
# see http://pecl.php.net/

# @ECLASS-VARIABLE: PHP_EXT_PECL_PKG
# @DESCRIPTION:
# Set in ebuild before inheriting this eclass if the tarball name
# differs from ${PN/pecl-/} so that SRC_URI and HOMEPAGE get set
# correctly by the eclass.
#
# Setting this variable manually also affects PHP_EXT_NAME and ${S}
# unless you override those in ebuild. If that is not desired, please
# use PHP_EXT_PECL_FILENAME instead.
[[ -z "${PHP_EXT_PECL_PKG}" ]] && PHP_EXT_PECL_PKG="${PN/pecl-/}"

# @ECLASS-VARIABLE: PHP_EXT_PECL_FILENAME
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set in ebuild before inheriting this eclass if the tarball name
# differs from "${PN/pecl-/}-${PV}.tgz" so that SRC_URI gets set
# correctly by the eclass.
#
# Unlike PHP_EXT_PECL_PKG, setting this variable does not affect
# HOMEPAGE, PHP_EXT_NAME or ${S}.


# Set PHP_EXT_NAME for php-ext-source-r3.eclass.
[[ -z "${PHP_EXT_NAME}" ]] && PHP_EXT_NAME="${PHP_EXT_PECL_PKG}"

# Try to guess the upstream name of the package/version. We only use
# this variable temporarily before unsetting it.
PHP_EXT_PECL_PKG_V="${PHP_EXT_PECL_PKG}-${PV/_/}"

# It's important that we determine and set $S before we inherit below.
S="${WORKDIR}/${PHP_EXT_PECL_PKG_V}"

inherit php-ext-source-r3

EXPORT_FUNCTIONS src_install src_test

if [[ -z "${PHP_EXT_PECL_FILENAME}" ]] ; then
	SRC_URI="http://pecl.php.net/get/${PHP_EXT_PECL_PKG_V}.tgz"
else
	SRC_URI="http://pecl.php.net/get/${PHP_EXT_PECL_FILENAME}"
fi

# Don't leave this laying around in the environment.
unset PHP_EXT_PECL_PKG_V

HOMEPAGE="http://pecl.php.net/${PHP_EXT_PECL_PKG}"


# @FUNCTION: php-ext-pecl-r3_src_install
# @DESCRIPTION:
# Install a standard PECL package. First we delegate to
# php-ext-source-r3.eclass, and then we attempt to install examples
# found in a standard location.
php-ext-pecl-r3_src_install() {
	php-ext-source-r3_src_install

	if in_iuse examples && use examples ; then
		dodoc -r examples
	fi
}


# @FUNCTION: php-ext-pecl-r3_src_test
# @DESCRIPTION:
# Run tests delivered with the PECL package. Phpize will have generated
# a run-tests.php file to be executed by `make test`. We only need to
# force the test suite to run in non-interactive mode.
php-ext-pecl-r3_src_test() {
	for slot in $(php_get_slots); do
		php_init_slot_env "${slot}"
		NO_INTERACTION="yes" emake test
	done
}
