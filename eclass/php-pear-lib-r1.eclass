# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: php-pear-lib-r1.eclass
# @MAINTAINER:
# Gentoo PHP team <php-bugs@gentoo.org>
# @AUTHOR:
# Author: Luca Longinotti <chtekk@gentoo.org>
# @BLURB: Provides means for an easy installation of PEAR-based libraries.
# @DESCRIPTION:
# This class provides means for an easy installation of PEAR-based libraries,
# such as Creole, Jargon, Phing etc., while retaining the functionality to put
# the libraries into version-dependant directories.

inherit multilib

EXPORT_FUNCTIONS pkg_setup src_install

# Silence repoman warnings
case "${EAPI:-0}" in
	5)
		PHP_DEPEND="dev-lang/php:*"
		;;
	*)
		PHP_DEPEND="dev-lang/php"
		;;
esac

DEPEND="${PHP_DEPEND}
		 >=dev-php/pear-1.9.0"
RDEPEND="${DEPEND}"

if [[ -n $PHP_PEAR_CHANNEL ]] ; then
	PHP_PEAR_PV=${PV/_rc/RC}
	[[ -z ${PHP_PEAR_PN} ]] && die "Missing PHP_PEAR_PN. Please notify the maintainer"
	PHP_PEAR_P=${PHP_PEAR_PN}-${PHP_PEAR_PV}

	S="${WORKDIR}/${PHP_PEAR_P}"

	SRC_URI="http://${PHP_PEAR_URI}/get/${PHP_PEAR_P}.tgz"
fi


# @FUNCTION: php-pear-lib-r1_pkg_setup
# @DESCRIPTION:
# Adds required PEAR channel if necessary
php-pear-lib-r1_pkg_setup() {
	if [[ -n $PHP_PEAR_CHANNEL ]] ; then
		if [[ -f $PHP_PEAR_CHANNEL ]]; then
		 	pear channel-add $PHP_PEAR_CHANNEL || einfo "Ignore any errors about existing channels"
		else
			die "Could not find channel file $PHP_PEAR_CHANNEL"
		fi
	fi
}


# @FUNCTION: php-pear-lib-r1_src_install
# @DESCRIPTION:
# Takes care of standard install for PEAR-based libraries.
php-pear-lib-r1_src_install() {
	# SNMP support
	addpredict /usr/share/snmp/mibs/.index
	addpredict /var/lib/net-snmp/
	addpredict /var/lib/net-snmp/mib_indexes
	addpredict /session_mm_cli0.sem

	PHP_BIN="/usr/bin/php"

	cd "${S}"

	# metadata_dir needs to be set relative to ${D} for >=dev-php/PEAR-PEAR-1.10
	if [[ -f "${WORKDIR}"/package2.xml ]] ; then
		mv -f "${WORKDIR}/package2.xml" "${S}"
		local WWW_DIR="/usr/share/webapps/${PN}/${PVR}/htdocs"
		peardev -d php_bin="${PHP_BIN}" -d www_dir="${WWW_DIR}" -d metadata_dir="/usr/share/php" \
			install --force --loose --nodeps --offline --packagingroot="${D}" \
			"${S}/package2.xml" || die "Unable to install PEAR package"
	else
		mv -f "${WORKDIR}/package.xml" "${S}"
		local WWW_DIR="/usr/share/webapps/${PN}/${PVR}/htdocs"
		peardev -d php_bin="${PHP_BIN}" -d www_dir="${WWW_DIR}" -d metadata_dir="/usr/share/php" \
			install --force --loose --nodeps --offline --packagingroot="${D}" \
			"${S}/package.xml" || die "Unable to install PEAR package"
	fi

	rm -Rf "${D}/usr/share/php/.channels" \
	"${D}/usr/share/php/.depdblock" \
	"${D}/usr/share/php/.depdb" \
	"${D}/usr/share/php/.filemap" \
	"${D}/usr/share/php/.lock" \
	"${D}/usr/share/php/.registry"

	einfo
	einfo "Installing to /usr/share/php ..."
	einfo
}
