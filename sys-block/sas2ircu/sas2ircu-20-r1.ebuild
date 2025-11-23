# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=SAS2IRCU
MY_P="${MY_PN}_P${PV}"

DISTFILE_BIN=${MY_P}.zip
DISTFILE_DOC="SAS2IRCU_User_Guide.pdf"
DOC_PV=12
SRC_URI_BIN="https://docs.broadcom.com/docs/${DISTFILE_BIN}"
# This is "SAS-2 Integrated RAID Configuration Utility (SAS2IRCU) User Guide"
# and replaces the older SAS2_IR_User_Guide.pdf.
# It contains additional material compared to the older PDF.
SRC_URI_DOC="https://docs.broadcom.com/doc/12353380"

inherit mount-boot secureboot

DESCRIPTION="LSI MPT-SAS2 controller management tool"
HOMEPAGE="https://www.broadcom.com/products/storage/host-bus-adapters/sas-9207-8e#tab-archive-drivers4-abc"
SRC_URI="
${SRC_URI_BIN}
doc? ( ${SRC_URI_DOC} -> ${DISTFILE_DOC} )
"
S="${WORKDIR}/${MY_P}"

LICENSE="LSI"
SLOT="0"
KEYWORDS="-* ~amd64 ~ppc64 ~x86 ~x64-solaris"
IUSE="doc uefi"
RESTRICT="strip fetch mirror"

BDEPEND="app-arch/unzip"
QA_PREBUILT="opt/lsi/sas2ircu boot/efi/sas2ircu.efi"

LICENSE_URL="http://www.lsi.com/cm/License.do?url=&prodName=&subType=Miscellaneous&locale=EN"

pkg_nofetch() {
	elog "LSI has a mandatory click-through license on thier binaries."
	elog "Please visit ${SRC_URI_BIN} to agree to the license and download the binary."
	elog "After downloading, move ${DISTFILE_BIN} into your DISTDIR directory"
	if use doc; then
		elog "Please also download 'SAS-2 Integrated RAID Configuration Utility User Guide' at ${SRC_URI_DOC}"
		elog "and also place it into your DISTDIR directory, named ${DISTFILE_DOC}"
	fi
}

supportedcards() {
	elog "This binary supports should support ALL cards, including, but not"
	elog "limited to the following series:"
	elog ""
	elog "LSI SAS 2004"
	elog "LSI SAS 2008"
	elog "LSI SAS 2108"
	elog "LSI SAS 2208"
	elog "LSI SAS 2304"
	elog "LSI SAS 2308"
	elog "Dell PERC H200, H700"
	elog "IBM System x3200 M2 (4367, 4368)"
	elog "IBM System x3200 M3 (7327, 7328)"
	elog "IBM System x3250 M2 (4190, 4191, 4194)"
	elog "IBM System x3250 M3 (4251, 4252, 4261)"
	elog "IBM System x3350 (4192, 4193)"
	elog "IBM System x3400 (7973, 7974, 7975, 7976)"
	elog "IBM System x3400 M2 (7836, 7837)"
	elog "IBM System x3455 (7940, 7941)"
	elog "IBM System x3500 (7977)"
	elog "IBM System x3500 M2 (7839)"
	elog "IBM System x3550 (7978, 1913)"
	elog "IBM System x3550 M2 (7946, 4198)"
	elog "IBM System x3650 (7979, 1914)"
	elog "IBM System x3650 M2 (7947, 4199)"
	elog "IBM System x3650 NAS (7979)"
	elog "IBM System x3655 (7985, 7943)"
	elog "IBM System x3755 (8877, 7163)"
	elog "IBM System x3850 M2 (7141, 7144, 7233, 7234)"
	elog "IBM System x3850 X5 (7145, 7146)"
	elog "IBM System x3950 M2 (7141, 7233, 7234)"
	elog "IBM System x3950 X5 (7145)"
}

src_unpack() {
	unpack ${DISTFILE_BIN}
}

src_install() {
	exeinto /opt/lsi/
	use amd64 || use x86 && doexe sas2ircu_linux_x86_rel/sas2ircu
	use ppc64 && doexe sas2ircu_linux_x86_rel/sas2ircu
	use x64-solaris && doexe sas2ircu_solaris_x86_rel/sas2ircu
	if use uefi; then
		if use amd64; then
			exeinto /boot/efi/
			doexe sas2ircu_efi_ebc_rel/sas2ircu.efi
			secureboot_auto_sign --in-place
		fi
	fi
	dodoc Readme_Release_Notes_SAS2IRCU_Phase_${PV}.00.00.00.txt
	dodoc SAS2IRCU_Phase${PV}.0-${PV}.00.00.00.pdf
	use doc && dodoc "${DISTDIR}"/${DISTFILE_DOC}
	dodir /opt/bin
	dosym ../lsi/sas2ircu /opt/bin/sas2ircu
}
