# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="PEAR Base System"
HOMEPAGE="http://pear.php.net/package/${MY_PN}"
SRC_URI="http://pear.php.net/get/${MY_P}.tgz"
LICENSE="MIT"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/php:*[cli,xml,zlib]
	>=dev-php/PEAR-Archive_Tar-1.4.0
	>=dev-php/PEAR-Console_Getopt-1.4.1
	>=dev-php/PEAR-Structures_Graph-1.1.0
	>=dev-php/PEAR-XML_Util-1.3.0"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}/gentoo-libtool-mismatch-fix-v2.patch" )

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

src_install() {
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
	[[ -z "${PEAR}" ]] && PEAR="${PV}"
	for i in pearcmd.php peclcmd.php ; do
		sed "s:@pear_version@:${PEAR}:g" -i "${D}/usr/share/php/${i}" \
			|| die "failed to sed pear_version"
	done

	for i in pear peardev pecl ; do
		sed "s:@bin_dir@:${EPREFIX}/usr/bin:g" -i "${D}/usr/bin/${i}" \
			|| die "failed to sed @bin_dir@ in ${i}"
		sed "s:@php_dir@:${EPREFIX}/usr/share/php:g" -i "${D}/usr/bin/${i}" \
			|| die "failed to sed @php_dir@ in ${i}"
	done

	sed "s:-d output_buffering=1:-d output_buffering=1 -d memory_limit=32M:g" \
		-i "${D}/usr/bin/pear" \
		|| die "failed to set PHP ini values in pear executable"

	sed "s:@package_version@:${PEAR}:g" \
		-i "${D}/usr/share/php/PEAR/Command/Package.php" \
		|| die "failed to sed @package_version@"

	sed "s:@PEAR-VER@:${PEAR}:g" \
		-i "${D}/usr/share/php/PEAR/Dependency2.php" \
		|| die "failed to sed @PEAR-VER@ in Dependency2.php"

	sed "s:@PEAR-VER@:${PEAR}:g" \
		-i "${D}/usr/share/php/PEAR/PackageFile/Parser/v1.php" \
		|| die "failed to sed @PEAR-VER@ in v1.php"

	sed "s:@PEAR-VER@:${PEAR}:g" \
		-i "${D}/usr/share/php/PEAR/PackageFile/Parser/v2.php" \
		|| die "failed to sed @PEAR-VER@ in v2.php"

	# finalize install
	insinto /etc
	newins "${FILESDIR}"/pear.conf-r2 pear.conf

	sed "s|s:PHPCLILEN:\"PHPCLI\"|s:${#PHPCLI}:\"${PHPCLI}\"|g" \
		-i "${D}/etc/pear.conf" \
		|| die "failed to sed PHPCLILEN in pear.conf"

	sed "s|s:CACHEDIRLEN:\"CACHEDIR\"|s:${#PEAR_CACHEDIR}:\"${PEAR_CACHEDIR}\"|g" \
		-i "${D}/etc/pear.conf" \
		|| die "failed to sed CACHEDIRLEN in pear.conf"

	sed "s|s:DOWNLOADDIRLEN:\"DOWNLOADDIR\"|s:${#PEAR_DOWNLOADDIR}:\"${PEAR_DOWNLOADDIR}\"|g" \
		-i "${D}/etc/pear.conf" \
		|| die "failed to sed DOWNLOADDIRLEN in pear.conf"

	sed "s|s:TEMPDIRLEN:\"TEMPDIR\"|s:${#PEAR_TEMPDIR}:\"${PEAR_TEMPDIR}\"|g" \
		-i "${D}/etc/pear.conf" \
		|| die "failed to sed TEMPDIRLEN in pear.conf"

	# Change the paths for eprefix!
	sed "s|s:19:\"/usr/share/php/docs\"|s:$(( ${#EPREFIX}+19 )):\"${EPREFIX}/usr/share/php/docs\"|g" \
		-i "${D}/etc/pear.conf" \
		|| die "failed to sed the docs path (prefix) in pear.conf"

	sed "s|s:19:\"/usr/share/php/data\"|s:$(( ${#EPREFIX}+19 )):\"${EPREFIX}/usr/share/php/data\"|g" \
		-i "${D}/etc/pear.conf" \
		|| die "failed to sed the data path (prefix) in pear.conf"

	sed "s|s:20:\"/usr/share/php/tests\"|s:$(( ${#EPREFIX}+20 )):\"${EPREFIX}/usr/share/php/tests\"|g" \
		-i "${D}/etc/pear.conf" \
		|| die "failed to sed the tests path (prefix) in pear.conf"

	sed "s|s:14:\"/usr/share/php\"|s:$(( ${#EPREFIX}+14 )):\"${EPREFIX}/usr/share/php\"|g" \
		-i "${D}/etc/pear.conf" \
		|| die "failed to sed the PHP include path (prefix) in pear.conf"

	sed "s|s:8:\"/usr/bin\"|s:$(( ${#EPREFIX}+8 )):\"${EPREFIX}/usr/bin\"|g" \
		-i "${D}/etc/pear.conf" \
		|| die "failed to sed the bin path (prefix) in pear.conf"

	[[ "${PEAR_TEMPDIR}" != "/tmp" ]] && keepdir "${PEAR_TEMPDIR#${EPREFIX}}"
	keepdir "${PEAR_CACHEDIR#${EPREFIX}}"
	diropts -m1777
	keepdir "${PEAR_DOWNLOADDIR#${EPREFIX}}"

	insinto /usr/share/php/.packagexml
	newins "${WORKDIR}/package.xml" "${MY_P}.xml"
}

pkg_postinst() {
	pear clear-cache || die "failed to clear PEAR cache"

	# Update PEAR/PECL channels as needed, add new ones to the list if needed
	elog "Updating PEAR/PECL channels"
	local pearchans="pear.php.net pecl.php.net pear.phing.info "
	pearchans+="pear.symfony-project.com"

	for chan in ${pearchans} ; do
		# The first command may fail if, for example, the channels have
		# already been initialized.
		pear channel-discover ${chan}
		pear channel-update ${chan} || die "failed to update channels: ${chan}"
	done

	# Register the package from the package.xml file
	# It is not critical to complete so only warn on failure
	if [[ -f "${EROOT}usr/share/php/.packagexml/${MY_P}.xml" ]] ; then
		"${EROOT}usr/bin/peardev" install -nrO --force \
			"${EROOT}usr/share/php/.packagexml/${MY_P}.xml" 2> /dev/null \
			|| ewarn "Failed to insert package into local PEAR database"
	fi
}

pkg_prerm() {
	# Uninstall known dependency
	"${EROOT}usr/bin/peardev" uninstall -nrO "pear.php.net/PEAR"
}
