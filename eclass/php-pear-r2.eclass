# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: php-pear-r2.eclass
# @MAINTAINER:
# Gentoo PHP Team <php-bugs@gentoo.org>
# @AUTHOR:
# Author: Brian Evans <grknight@gentoo.org>
# @SUPPORTED_EAPIS: 6 7 8
# @BLURB: Provides means for an easy installation of PEAR packages.
# @DESCRIPTION:
# This eclass provides means for an easy installation of PEAR packages.
# For more information on PEAR, see https://pear.php.net/
# Note that this eclass doesn't handle dependencies of PEAR packages
# on purpose; please use (R)DEPEND to define them correctly!

EXPORT_FUNCTIONS src_install pkg_postinst pkg_postrm

case "${EAPI:-0}" in
	6|7)
		;;
	8)
		IDEPEND=">=dev-php/pear-1.8.1"
		;;
	*)
		die "Unsupported EAPI=${EAPI} for ${ECLASS}"
		;;
esac

RDEPEND=">=dev-php/pear-1.8.1"

# @ECLASS_VARIABLE: PHP_PEAR_PKG_NAME
# @DESCRIPTION:
# Set this if the PEAR package name differs from ${PN/PEAR-/}
# (generally shouldn't be the case).
: ${PHP_PEAR_PKG_NAME:=${PN/PEAR-/}}

# @ECLASS_VARIABLE: PEAR_PV
# @DESCRIPTION:
# Set in ebuild if the ${PV} breaks SRC_URI for alpha/beta/rc versions
: ${PEAR_PV:=${PV}}

# @ECLASS_VARIABLE: PEAR-P
# @INTERNAL
# @DESCRIPTION:
# Combines PHP_PEAR_PKG_NAME and PEAR_PV
PEAR_P="${PHP_PEAR_PKG_NAME}-${PEAR_PV}"

# @ECLASS_VARIABLE: PHP_PEAR_DOMAIN
# @DESCRIPTION:
# Set in ebuild to the domain name of the channel if not pear.php.net
# When the domain is not pear.php.net, setting the SRC_URI is required
: ${PHP_PEAR_DOMAIN:=pear.php.net}

# @ECLASS_VARIABLE: PHP_PEAR_CHANNEL
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set in ebuild to the path of channel.xml file which is necessary for
# 3rd party pear channels (besides pear.php.net) to be added to PEAR
# Default is unset to do nothing

# set default SRC_URI for pear.php.net packages
if [[ "${PHP_PEAR_DOMAIN}" == "pear.php.net" ]] ; then
	SRC_URI="https://pear.php.net/get/${PEAR_P}.tgz"
fi

: ${HOMEPAGE:=https://${PHP_PEAR_DOMAIN}/package/${PHP_PEAR_PKG_NAME}}

S="${WORKDIR}/${PEAR_P}"

# @FUNCTION: php-pear-r2_install_packagexml
# @DESCRIPTION:
# Copies the package2.xml or package.xml file and, optionally, the channel.xml
# file to a Gentoo-specific location so that pkg_postinst can install the package
# to the local PEAR database
php-pear-r2_install_packagexml() {
	insinto /usr/share/php/.packagexml
	if [[ -f "${WORKDIR}/package2.xml" ]] ; then
		newins "${WORKDIR}/package2.xml" "${PEAR_P}.xml"
	elif [[ -f "${WORKDIR}/package.xml" ]] ; then
		newins "${WORKDIR}/package.xml" "${PEAR_P}.xml"
	fi

	if [[ -f "${PHP_PEAR_CHANNEL}" ]] ; then
		newins "${PHP_PEAR_CHANNEL}" "${PEAR_P}-channel.xml"
	fi
}

# @FUNCTION: php-pear-r2_src_install
# @DESCRIPTION:
# Takes care of standard install for PEAR packages.
# Override src_install if the package installs more than "${PHP_PEAR_PKG_NAME}.php"
# or "${PHP_PEAR_PKG_NAME%%_*}/" as a directory
php-pear-r2_src_install() {
	insinto /usr/share/php
	[[ -f "${PHP_PEAR_PKG_NAME}.php" ]] && doins "${PHP_PEAR_PKG_NAME}.php"
	[[ -d "${PHP_PEAR_PKG_NAME%%_*}" ]] && doins -r "${PHP_PEAR_PKG_NAME%%_*}/"
	php-pear-r2_install_packagexml
	einstalldocs
}

# @FUNCTION: php-pear-r2_pkg_postinst
# @DESCRIPTION:
# Register package with the local PEAR database.
php-pear-r2_pkg_postinst() {
	# Add unknown channels
	if [[ -f "${EROOT%/}/usr/share/php/.packagexml/${PEAR_P}-channel.xml" ]] ; then
		"${EROOT%/}/usr/bin/peardev" channel-info "${PHP_PEAR_DOMAIN}" &> /dev/null
		if [[ $? -ne 0 ]]; then
			"${EROOT%/}/usr/bin/peardev" channel-add \
				"${EROOT%/}/usr/share/php/.packagexml/${PEAR_P}-channel.xml" \
				|| einfo "Ignore any errors about existing channels"
		fi
	fi

	# Register the package from the package{,2}.xml file
	# It is not critical to complete so only warn on failure
	if [[ -f "${EROOT%/}/usr/share/php/.packagexml/${PEAR_P}.xml" ]] ; then
		"${EROOT%/}/usr/bin/peardev" install -nrO --force \
			"${EROOT%/}/usr/share/php/.packagexml/${PEAR_P}.xml" 2> /dev/null \
			|| ewarn "Failed to insert package into local PEAR database"
	fi
}

# @FUNCTION: php-pear-r2_pkg_postrm
# @DESCRIPTION:
# Deregister package from the local PEAR database
php-pear-r2_pkg_postrm() {
	# Uninstall known dependency
	"${EROOT%/}/usr/bin/peardev" uninstall -nrO "${PHP_PEAR_DOMAIN}/${PHP_PEAR_PKG_NAME}"
}
