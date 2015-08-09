# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: php-ext-pecl-r1.eclass
# @MAINTAINER:
# Gentoo PHP team <php-bugs@gentoo.org>
# @AUTHOR:
# Author: Tal Peer <coredumb@gentoo.org>
# Author: Luca Longinotti <chtekk@gentoo.org>
# Author: Jakub Moc <jakub@gentoo.org>
# @BLURB: A uniform way of installing PECL extensions
# @DESCRIPTION:
# This eclass should be used by all dev-php[45]/pecl-* ebuilds
# as a uniform way of installing PECL extensions.
# For more information about PECL, see http://pecl.php.net/

# @ECLASS-VARIABLE: PHP_EXT_PECL_PKG
# @DESCRIPTION:
# Set in ebuild before inheriting this eclass if the tarball name
# differs from ${PN/pecl-/} so that SRC_URI and HOMEPAGE gets set
# correctly by the eclass.
#
# Setting this variable manually also affects PHP_EXT_NAME and ${S}
# unless you override those in ebuild. Also see PHP_EXT_PECL_FILENAME
# if this is not desired for whatever reason.

# @ECLASS-VARIABLE: PHP_EXT_PECL_FILENAME
# @DESCRIPTION:
# Set in ebuild before inheriting this eclass if the tarball name
# differs from ${PN/pecl-/} so that SRC_URI gets set correctly by
# the eclass.
#
# Unlike PHP_EXT_PECL_PKG, setting this variable does not affect
# HOMEPAGE, PHP_EXT_NAME or ${S}.


[[ -z "${PHP_EXT_PECL_PKG}" ]] && PHP_EXT_PECL_PKG="${PN/pecl-/}"


[[ -z ${MY_PV} ]] && MY_PV=${PV}

PECL_PKG="${PHP_EXT_PECL_PKG}"
MY_PV="${MY_PV/_/}"
PECL_PKG_V="${PECL_PKG}-${MY_PV}"

[[ -z "${PHP_EXT_NAME}" ]] && PHP_EXT_NAME="${PECL_PKG}"

S="${WORKDIR}/${PECL_PKG_V}"

inherit php-ext-source-r2

EXPORT_FUNCTIONS src_compile src_install src_test

if [[ -n "${PHP_EXT_PECL_FILENAME}" ]] ; then
	FILENAME="${PHP_EXT_PECL_FILENAME}-${MY_PV}.tgz"
else
	FILENAME="${PECL_PKG_V}.tgz"
fi

SRC_URI="http://pecl.php.net/get/${FILENAME}"
HOMEPAGE="http://pecl.php.net/${PECL_PKG}"


# @FUNCTION: php-ext-pecl-r1_src_compile
# @DESCRIPTION:
# Takes care of standard compile for PECL packages.
php-ext-pecl-r2_src_compile() {
	php-ext-source-r2_src_compile
}

# @FUNCTION: php-ext-pecl-r1_src_install
# @DESCRIPTION:
# Takes care of standard install for PECL packages.
# You can also simply add examples to IUSE to automagically install
# examples supplied with the package.

# @VARIABLE: DOCS
# @DESCRIPTION:
# Set in ebuild if you wish to install additional, package-specific documentation.
php-ext-pecl-r2_src_install() {
	php-ext-source-r2_src_install

	for doc in ${DOCS} "${WORKDIR}"/package.xml CREDITS ; do
		[[ -s ${doc} ]] && dodoc ${doc}
	done

	if has examples ${IUSE} && use examples ; then
		insinto /usr/share/doc/${CATEGORY}/${PF}/examples
		doins -r examples/*
	fi
}


# @FUNCTION: php-ext-pecl-r2_src_test
# @DESCRIPTION:
# Takes care of running any tests delivered with the PECL package.
# Standard phpize generates a run-tests.php file that is executed in make test
# We only need to force it to non-interactive mode
php-ext-pecl-r2_src_test() {
	for slot in `php_get_slots`; do
		php_init_slot_env ${slot}
		NO_INTERACTION="yes" emake test || die "emake test failed for slot ${slot}"
	done
}
