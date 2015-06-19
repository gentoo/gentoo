# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/php-pear-r1.eclass,v 1.33 2015/02/11 02:53:18 grknight Exp $

# @ECLASS: php-pear-r1.eclass
# @MAINTAINER:
# Gentoo PHP Team <php-bugs@gentoo.org>
# @AUTHOR:
# Author: Tal Peer <coredumb@gentoo.org>
# Author: Luca Longinotti <chtekk@gentoo.org>
# @BLURB: Provides means for an easy installation of PEAR packages.
# @DESCRIPTION:
# This eclass provides means for an easy installation of PEAR packages.
# For more information on PEAR, see http://pear.php.net/
# Note that this eclass doesn't handle dependencies of PEAR packages
# on purpose; please use (R)DEPEND to define them correctly!

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
	 >=dev-php/pear-1.8.1"
RDEPEND="${DEPEND}"

# @ECLASS-VARIABLE: PHP_PEAR_PKG_NAME
# @DESCRIPTION:
# Set this if the the PEAR package name differs from ${PN/PEAR-/}
# (generally shouldn't be the case).
[[ -z "${PHP_PEAR_PKG_NAME}" ]] && PHP_PEAR_PKG_NAME="${PN/PEAR-/}"

fix_PEAR_PV() {
	tmp="${PV}"
	tmp="${tmp/_/}"
	tmp="${tmp/rc/RC}"
	tmp="${tmp/beta/b}"
	tmp="${tmp/alpha/a}"
	PEAR_PV="${tmp}"
}

# @ECLASS-VARIABLE: PEAR_PV
# @DESCRIPTION:
# Set in ebuild if the eclass ${PV} mangling breaks SRC_URI for alpha/beta/rc versions
[[ -z "${PEAR_PV}" ]] && fix_PEAR_PV

PEAR_PN="${PHP_PEAR_PKG_NAME}-${PEAR_PV}"
: ${PHP_PEAR_URI:=pear.php.net}
: ${PHP_PEAR_CHANNEL:=${FILESDIR}/channel.xml}

[[ -z "${SRC_URI}" ]] && SRC_URI="http://${PHP_PEAR_URI}/get/${PEAR_PN}.tgz"
[[ -z "${HOMEPAGE}" ]] && HOMEPAGE="http://${PHP_PEAR_URI}/${PHP_PEAR_PKG_NAME}"

S="${WORKDIR}/${PEAR_PN}"

# @FUNCTION: php-pear-lib-r1_pkg_setup
# @DESCRIPTION:
# Adds required PEAR channel if necessary
php-pear-r1_pkg_setup() {
	if [[ -f $PHP_PEAR_CHANNEL ]]; then
		pear channel-add $PHP_PEAR_CHANNEL || einfo "Ignore any errors about existing channels"
	fi
}

# @FUNCTION: php-pear-r1_src_install
# @DESCRIPTION:
# Takes care of standard install for PEAR packages.
php-pear-r1_src_install() {
	# SNMP support
	addpredict /usr/share/snmp/mibs/.index
	addpredict /var/lib/net-snmp/
	addpredict /var/lib/net-snmp/mib_indexes
	addpredict /session_mm_cli0.sem

	PHP_BIN="/usr/bin/php"

	cd "${S}"

	if [[ -f "${WORKDIR}"/package2.xml ]] ; then
		mv -f "${WORKDIR}/package2.xml" "${S}"
		if has_version '>=dev-php/PEAR-PEAR-1.7.0' ; then
			local WWW_DIR="/usr/share/webapps/${PN}/${PVR}/htdocs"
			peardev -d php_bin="${PHP_BIN}" -d www_dir="${WWW_DIR}" \
				install --force --loose --nodeps --offline --packagingroot="${D}" \
				"${S}/package2.xml" || die "Unable to install PEAR package"
		else
			peardev -d php_bin="${PHP_BIN}" install --force --loose --nodeps --offline --packagingroot="${D}" \
				"${S}/package2.xml" || die "Unable to install PEAR package"
		fi
	else
		mv -f "${WORKDIR}/package.xml" "${S}"
		if has_version '>=dev-php/PEAR-PEAR-1.7.0' ; then
			local WWW_DIR="/usr/share/webapps/${PN}/${PVR}/htdocs"
			peardev -d php_bin="${PHP_BIN}" -d www_dir="${WWW_DIR}" \
				install --force --loose --nodeps --offline --packagingroot="${D}" \
				"${S}/package.xml" || die "Unable to install PEAR package"
		else
			peardev -d php_bin="${PHP_BIN}" install --force --loose --nodeps --offline --packagingroot="${D}" \
				"${S}/package.xml" || die "Unable to install PEAR package"
		fi
	fi

	rm -Rf "${D}/usr/share/php/.channels" \
	"${D}/usr/share/php/.depdblock" \
	"${D}/usr/share/php/.depdb" \
	"${D}/usr/share/php/.filemap" \
	"${D}/usr/share/php/.lock" \
	"${D}/usr/share/php/.registry"
}
