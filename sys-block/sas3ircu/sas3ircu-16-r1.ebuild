# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${PN^^}_P${PV}"

DISTFILE_BIN="${MY_P}.zip"
DISTFILE_DOC="SAS3_IR_UG.pdf"
SRC_URI_BASE="https://docs.broadcom.com/docs-and-downloads/host-bus-adapters"

inherit mount-boot secureboot

DESCRIPTION="LSI MPT-SAS3 controller management tool"
HOMEPAGE="https://www.broadcom.com/products/storage/host-bus-adapters/sas-9300-8e#downloads"
SRC_URI="
	${SRC_URI_BASE}/host-bus-adapters-common-files/sas_sata_12g_p${PV}/${DISTFILE_BIN}
	https://docs.broadcom.com/docs/${DISTFILE_BIN}
	doc? ( "${SRC_URI_BASE}/${DISTFILE_DOC}" )
"
S="${WORKDIR}/${MY_P}"

LICENSE="LSI"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86 ~x64-solaris"
IUSE="doc efi"
RESTRICT="strip fetch mirror"

BDEPEND="app-arch/unzip"

QA_PREBUILT="opt/lsi/sas3ircu boot/efi/sas3ircu.efi"

pkg_nofetch() {
	elog "Broadcom has a mandatory click-through license on thier binaries."
	elog "Please visit ${HOMEPAGE} and download ${DISTFILE_BIN} from the Mangement Software section."
	elog "If the file has been moved again, the license form might be available at https://docs.broadcom.com/docs/${DISTFILE_BIN}"
	elog "After downloading, move ${MY_P} into your DISTDIR directory"
	if use doc; then
		elog "Please also download 'SAS-3 Integrated RAID Configuration Utility User Guide' (${DISTFILE_DOC}) "
		elog "and also place it into your DISTDIR directory"
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
	local DOCS=( IRCU_MPT_GEN3_Phase"${PV}".0-*.pdf "README_SAS3IRCU_P${PV}.txt" )
	use doc && DOCS+=( "${DISTDIR}/${DISTFILE_DOC}" )

	default

	local ARCH
	use amd64 && ARCH="x64"
	use arm64 && ARCH="arm"
	use ppc64 && ARCH="ppc64"
	use x64-solaris && ARCH="solaris_x86"
	use x86 && ARCH="x86"

	exeinto /opt/lsi/
	doexe sas3ircu_rel/sas3ircu/sas3ircu_linux_"${ARCH}"_rel/sas3ircu

	if use efi; then
		if use amd64 || use efi64; then
			exeinto /boot/efi/
			doexe sas3ircu_rel/sas3ircu/sas3ircu_udk_uefi_"${ARCH}"_rel/sas3ircu.efi
			secureboot_auto_sign --in-place
		fi
	fi

	dodir /opt/bin
	dosym ../lsi/sas3ircu /opt/bin/sas3ircu
}
