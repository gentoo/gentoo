# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit mount-boot

DESCRIPTION="Flash utility for LSI MPT-SAS3 controller"
HOMEPAGE="https://www.broadcom.com/products/storage/host-bus-adapters/sas-9300-8e#downloads"
LICENSE="LSI"
SLOT="0"
KEYWORDS="-* ~amd64 ~ppc64 ~x86 ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="efi doc"
RESTRICT="strip fetch mirror"
DEPEND=""
RDEPEND=""
QA_PREBUILT="opt/lsi/sas3flash boot/efi/sas3flash.efi"

MY_PN=SAS3FLASH
MY_P="${MY_PN}_P${PV}"

DISTFILE_BIN=${MY_P}.zip
DISTFILE_DOC=sas3Flash_quickRefGuide_rev1-0.pdf

SRC_URI_BASE='https://docs.broadcom.com/docs-and-downloads/host-bus-adapters'
SRC_URI="
	${SRC_URI_BASE}/host-bus-adapters-common-files/sas_sata_12g_p${PV}/${DISTFILE_BIN}
	doc? ( https://docs.broadcom.com/docs-and-downloads/oracle/files/${DISTFILE_DOC} )"

S="${WORKDIR}/${MY_P}"

pkg_nofetch() {
	elog "Broadcom has a mandatory click-through license on their binaries."
	elog "Please visit $HOMEPAGE and download ${DISTFILE_BIN} from the Mangement Software section."
	elog "After downloading, move ${DISTFILE_BIN} into your DISTDIR directory."
	if use doc; then
		elog "Please also download 'SAS3Flash Utility Quick Reference Guide' (${DISTFILE_DOC}) "
		elog "and also place it into your DISTDIR directory."
	fi
	einfo ${SRC_URI}
}

src_unpack() {
	unpack ${DISTFILE_BIN}
}

src_install() {
	exeinto /opt/lsi/
	use amd64 || use x86 && doexe sas3flash_rel/sas3flash/sas3flash_linux_x64_rel/sas3flash
	use ppc64 && doexe sas3flash_rel/sas3flash/sas3flash_linux_ppc64_rel/sas3flash
	use amd64-fbsd && doexe sas3flash_rel/sas3flash/sas3flash_freebsd_amd64_rel/sas3flash
	use x86-fbsd && doexe sas3flash_rel/sas3flash/sas3flash_freebsd_i386_rel/sas3flash
	use x64-solaris || use x86-solaris && doexe sas3flash_rel/sas3flash/sas3flash_solaris_x86_rel/sas3flash
	use sparc-solaris && doexe sas3flash_rel/sas3flash/sas3flash_solaris_sparc_rel/sas3flash
	if use efi; then
		exeinto /boot/efi/
		doexe sas3flash_rel/sas3flash/sas3flash_udk_uefi_x64_rel/sas3flash.efi
	fi
	dodoc FLASH_MPT_GEN3_Phase${PV}.0-*.pdf
	dodoc README_SAS3FLASH_P${PV}.txt
	use doc && dodoc "${DISTDIR}"/${DISTFILE_DOC}
}
