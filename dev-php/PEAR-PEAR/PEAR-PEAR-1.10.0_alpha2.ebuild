# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

PEAR="${PV//_alpha/dev}"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~ia64-linux ~x86-linux ~x64-macos ~x86-macos"

DESCRIPTION="PEAR Base System"
HOMEPAGE="http://pear.php.net/package/PEAR"
SRC_URI="http://pear.php.net/get/PEAR-${PEAR}.tgz"
LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND="dev-lang/php:*[cli,pcre(+),xml,zlib]"

RDEPEND="${DEPEND}"

PDEPEND="dev-php/pear"

S="${WORKDIR}"

pkg_setup() {
	[[ -z "${PEAR_CACHEDIR}" ]] && PEAR_CACHEDIR="${EPREFIX}/var/cache/pear"
	[[ -z "${PEAR_DOWNLOADDIR}" ]] && PEAR_DOWNLOADDIR="${EPREFIX}/var/tmp/pear"
	[[ -z "${PEAR_TEMPDIR}" ]] && PEAR_TEMPDIR="${EPREFIX}/tmp"

	elog
	elog "cache_dir is set to: ${PEAR_CACHEDIR}"
	elog "download_dir is set to: ${PEAR_DOWNLOADDIR}"
	elog "temp_dir is set to: ${PEAR_TEMPDIR}"
	elog
	elog "If you want to change the above values, you need to set"
	elog "PEAR_CACHEDIR, PEAR_DOWNLOADDIR and PEAR_TEMPDIR variable(s)"
	elog "accordingly in /etc/portage/make.conf and re-emerge ${PN}."
	elog
}

src_prepare() {
	cd PEAR-${PEAR}
	epatch "${FILESDIR}/gentoo-libtool-mismatch-fix-v2.patch"
	epatch_user
}

src_install() {
	# Prevent SNMP related sandbox violoation.
	addpredict /usr/share/snmp/mibs/.index
	addpredict /var/lib/net-snmp/

	# install PEAR package
	cd "${S}"/PEAR-${PEAR}

	insinto /usr/share/php
	doins -r PEAR/
	doins -r OS/
	doins PEAR.php System.php
	doins scripts/pearcmd.php
	doins scripts/peclcmd.php

	newbin scripts/pear.sh pear
	newbin scripts/peardev.sh peardev
	newbin scripts/pecl.sh pecl

	# adjust some scripts for current version
	for i in pearcmd.php peclcmd.php ; do
		sed "s:@pear_version@:${PEAR}:g" -i "${D}/usr/share/php/${i}"
	done

	for i in pear peardev pecl ; do
		sed "s:@bin_dir@:${EPREFIX}/usr/bin:g" -i "${D}/usr/bin/${i}"
		sed "s:@php_dir@:${EPREFIX}/usr/share/php:g" -i "${D}/usr/bin/${i}"
	done
	sed "s:-d output_buffering=1:-d output_buffering=1 -d memory_limit=32M:g" -i "${D}/usr/bin/pear"

	sed "s:@package_version@:${PEAR}:g" -i "${D}/usr/share/php/PEAR/Command/Package.php"
	sed "s:@PEAR-VER@:${PEAR}:g" -i "${D}/usr/share/php/PEAR/Dependency2.php"
	sed "s:@PEAR-VER@:${PEAR}:g" -i "${D}/usr/share/php/PEAR/PackageFile/Parser/v1.php"
	sed "s:@PEAR-VER@:${PEAR}:g" -i "${D}/usr/share/php/PEAR/PackageFile/Parser/v2.php"

	# finalize install
	insinto /etc
	newins "${FILESDIR}"/pear.conf-r2 pear.conf
	sed "s|s:PHPCLILEN:\"PHPCLI\"|s:${#PHPCLI}:\"${PHPCLI}\"|g" -i "${D}/etc/pear.conf"
	sed "s|s:CACHEDIRLEN:\"CACHEDIR\"|s:${#PEAR_CACHEDIR}:\"${PEAR_CACHEDIR}\"|g" -i "${D}/etc/pear.conf"
	sed "s|s:DOWNLOADDIRLEN:\"DOWNLOADDIR\"|s:${#PEAR_DOWNLOADDIR}:\"${PEAR_DOWNLOADDIR}\"|g" -i "${D}/etc/pear.conf"
	sed "s|s:TEMPDIRLEN:\"TEMPDIR\"|s:${#PEAR_TEMPDIR}:\"${PEAR_TEMPDIR}\"|g" -i "${D}/etc/pear.conf"

	# Change the paths for eprefix!
	sed "s|s:19:\"/usr/share/php/docs\"|s:$(( ${#EPREFIX}+19 )):\"${EPREFIX}/usr/share/php/docs\"|g" -i "${D}/etc/pear.conf"
	sed "s|s:19:\"/usr/share/php/data\"|s:$(( ${#EPREFIX}+19 )):\"${EPREFIX}/usr/share/php/data\"|g" -i "${D}/etc/pear.conf"
	sed "s|s:20:\"/usr/share/php/tests\"|s:$(( ${#EPREFIX}+20 )):\"${EPREFIX}/usr/share/php/tests\"|g" -i "${D}/etc/pear.conf"
	sed "s|s:14:\"/usr/share/php\"|s:$(( ${#EPREFIX}+14 )):\"${EPREFIX}/usr/share/php\"|g" -i "${D}/etc/pear.conf"
	sed "s|s:8:\"/usr/bin\"|s:$(( ${#EPREFIX}+8 )):\"${EPREFIX}/usr/bin\"|g" -i "${D}/etc/pear.conf"

	[[ "${PEAR_TEMPDIR}" != "/tmp" ]] && keepdir "${PEAR_TEMPDIR#${EPREFIX}}"
	keepdir "${PEAR_CACHEDIR#${EPREFIX}}"
	diropts -m1777
	keepdir "${PEAR_DOWNLOADDIR#${EPREFIX}}"
}

pkg_preinst() {
	rm -f "${EROOT}/etc/pear.conf"
}
