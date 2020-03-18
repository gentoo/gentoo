# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit mount-boot

DESCRIPTION="Flash utility for LSI MPT-SAS3 controller"
HOMEPAGE="https://www.broadcom.com/products/storage/host-bus-adapters/sas-9300-8e#downloads"

LICENSE="LSI"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86 ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc efi"

RESTRICT="strip fetch mirror"
BDEPEND="app-arch/unzip"
QA_PREBUILT="opt/lsi/sas3flash boot/efi/sas3flash.efi"

MY_PN=SAS3FLASH
MY_P="${MY_PN}_P${PV}"

DISTFILE_BIN=${MY_P}.zip
DISTFILE_DOC=sas3Flash_quickRefGuide_rev1-0.pdf

SRC_URI_BASE='https://docs.broadcom.com/docs-and-downloads'
SRC_URI="
	${SRC_URI_BASE}/host-bus-adapters/host-bus-adapters-common-files/sas_sata_12g_p${PV}/${DISTFILE_BIN}
	doc? ( "${SRC_URI_BASE}/oracle/files/${DISTFILE_DOC}" )"

S="${WORKDIR}/${MY_P}"

pkg_nofetch() {
	elog "Broadcom has a mandatory click-through license on their binaries."
	elog "Please visit ${HOMEPAGE} and download ${DISTFILE_BIN} from the Mangement Software section."
	elog "After downloading, move ${DISTFILE_BIN} into your DISTDIR directory."
	if use doc; then
		elog "Please also download 'SAS3Flash Utility Quick Reference Guide' (${DISTFILE_DOC}) "
		elog "and also place it into your DISTDIR directory."
	fi
	einfo "${SRC_URI}"
}

supportedcards() {
	elog "This binary supports should support ALL cards, including, but not"
	elog "limited to the following series:"
	elog ""
	elog "LSI SAS 3004"
	elog "LSI SAS 3008"
	elog "LSI SAS 3108"
	elog "LSI SAS 3116"
	elog "LSI SAS 3208"
	elog "LSI SAS 3308"
}

src_install() {
	# The second number is some sort of internal revision that is inconsistent between releases.
	local DOCS=( FLASH_MPT_GEN3_Phase"${PV}".0-*.pdf "README_SAS3FLASH_P${PV}.txt" )

	if use doc; then
		DOCS+=( "${DISTDIR}/${DISTFILE_DOC}" )
	fi

	default

	exeinto /opt/lsi/
	if use amd64; then
		doexe sas3flash_rel/sas3flash/sas3flash_linux_x64_rel/sas3flash
	elif use x86; then
		doexe sas3flash_rel/sas3flash/sas3flash_linux_x86_rel/sas3flash
	elif use arm64; then
		doexe sas3flash_rel/sas3flash/sas3flash_linux_arm_rel/sas3flash
	elif use ppc64; then
		doexe sas3flash_rel/sas3flash/sas3flash_linux_ppc64_rel/sas3flash
	elif use amd64-fbsd; then
		doexe sas3flash_rel/sas3flash/sas3flash_freebsd_amd64_rel/sas3flash
	elif use x86-fbsd; then
		doexe sas3flash_rel/sas3flash/sas3flash_freebsd_i386_rel/sas3flash
	elif use x64-solaris || use x86-solaris; then
		doexe sas3flash_rel/sas3flash/sas3flash_solaris_x86_rel/sas3flash
	elif use sparc-solaris; then
		doexe sas3flash_rel/sas3flash/sas3flash_solaris_sparc_rel/sas3flash
	fi

	if use efi; then
		exeinto /boot/efi/
		if use amd64; then
			doexe sas3flash_rel/sas3flash/sas3flash_udk_uefi_x64_rel/sas3flash.efi
		elif use arm64; then
			doexe sas3flash_rel/sas3flash/sas3flash_udk_uefi_arm_rel/sas3flash.efi
		fi
	fi
}
