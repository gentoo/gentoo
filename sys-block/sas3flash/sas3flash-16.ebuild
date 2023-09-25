# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit mount-boot secureboot

DESCRIPTION="Flash utility for LSI MPT-SAS3 controller"
HOMEPAGE="https://www.broadcom.com/products/storage/host-bus-adapters/sas-9300-8e#downloads"

LICENSE="LSI"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86 ~x64-solaris"
IUSE="doc efi"

RESTRICT="strip fetch mirror"
BDEPEND="app-arch/unzip"
QA_PREBUILT="opt/lsi/sas3flash boot/efi/sas3flash.efi"

SRC_URI_BASE="https://docs.broadcom.com/docs-and-downloads"
SRC_URI_PREFIX="${SRC_URI_BASE}/host-bus-adapters/host-bus-adapters-common-files/sas_sata_12g_p${PV}_point_release"

SRC_URI_LINUX="${SRC_URI_PREFIX}/Installer_P${PV}_for_Linux.zip"
SRC_URI_SOLARIS="${SRC_URI_PREFIX}/Installer_P${PV}_for_Solaris.zip"
SRC_URI_UEFI="${SRC_URI_PREFIX}/Installer_P${PV}_for_UEFI.zip"

DISTFILE_BINS=( "${SRC_URI_LINUX##*/}" "${SRC_URI_SOLARIS##*/}" "${SRC_URI_UEFI##*/}" )
DISTFILE_DOC=sas3Flash_quickRefGuide_rev1-0.pdf

SRC_URI="
	amd64? ( ${SRC_URI_LINUX} )
	x86? ( ${SRC_URI_LINUX} )
	ppc64? ( ${SRC_URI_LINUX} )
	x64-solaris? ( ${SRC_URI_SOLARIS} )
	efi? ( ${SRC_URI_UEFI} )
	doc? ( "${SRC_URI_BASE}/oracle/files/${DISTFILE_DOC}" )"

S="${WORKDIR}"

pkg_nofetch() {
	elog "Broadcom has a mandatory click-through license on their binaries."
	elog "Please visit ${HOMEPAGE} and download ${DISTFILE_BINS[@]} from the Mangement Software section."
	elog "After downloading, move ${DISTFILE_BINS[@]} into your DISTDIR directory."
	if use doc; then
		elog "Please also download 'SAS3Flash Utility Quick Reference Guide' (${DISTFILE_DOC}) "
		elog "and also place it into your DISTDIR directory."
	fi
	einfo "${SRC_URI}"
}

pkg_setup() {
	use efi && secureboot_pkg_setup
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
	local DOCS=( Installer_P"${PV}"_for_Linux/{FLASH_MPT_GEN3_Phase"${PV}".0-*.pdf,sas3Flash_quickRefGuide_rev1-0.pdf} )

	if use doc; then
		DOCS+=( "${DISTDIR}/${DISTFILE_DOC}" )
	fi

	exeinto /opt/lsi/
	if use amd64; then
		doexe Installer_P16_for_Linux/sas3flash_linux_x64_rel/sas3flash
		DOCS+=( Installer_P"${PV}"_for_Linux/README_Installer_P"${PV}"_Linux.txt )
	elif use x86; then
		doexe Installer_P16_for_Linux/sas3flash_linux_i386_rel/sas3flash
		DOCS+=( Installer_P"${PV}"_for_Linux/README_Installer_P"${PV}"_Linux.txt )
	elif use ppc64; then
		doexe Installer_P16_for_Linux/sas3flash_linux_ppc64_rel/sas3flash
		DOCS+=( Installer_P"${PV}"_for_Linux/README_Installer_P"${PV}"_Linux.txt )
	elif use x64-solaris; then
		doexe Installer_P16_for_Solaris/sas3flash_solaris_x86_rel/sas3flash
		DOCS+=( Installer_P"${PV}"_for_Solaris/README_Installer_P"${PV}"_Solaris.txt )
	fi

	if use efi; then
		exeinto /boot/efi/
		DOCS+=( Installer_P"${PV}"_for_UEFI/README_Installer_P"${PV}"_UEFI.txt )
		if use amd64; then
			doexe Installer_P"${PV}"_for_UEFI/sas3flash_udk_uefi_x64_rel/sas3flash.efi
		fi
		secureboot_auto_sign --in-place
	fi

	default
}
