# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit mount-boot

DESCRIPTION="LSI MPT-SAS3 controller management tool"
HOMEPAGE="http://www.lsi.com/support/Pages/download-results.aspx?component=Storage+Component&productfamily=Host+Bus+Adapters&productcode=0&assettype=Miscellaneous&productname=&keyword=SAS3IRCU"
LICENSE="LSI"
SLOT="0"
KEYWORDS="-* ~amd64 ~ppc64 ~x86 ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="efi doc"
RESTRICT="strip fetch mirror"
DEPEND=""
RDEPEND=""
QA_PREBUILT="opt/lsi/sas3ircu boot/efi/sas3ircu.efi"

MY_PN=SAS3IRCU
MY_P="${MY_PN}_P${PV}"

DISTFILE_BIN=${MY_P}.zip
DISTFILE_DOC=SAS3IRCU_UG.pdf

SRC_URI="
http://www.lsi.com/downloads/Public/Host%20Bus%20Adapters/Host%20Bus%20Adapters%20Common%20Files/SAS_SATA_12G_P${PV}/${DISTFILE_BIN}
doc? ( http://www.lsi.com/downloads/Public/Host%20Bus%20Adapters/${DISTFILE_DOC} )
"

LICENSE_URL="http://www.lsi.com/cm/License.do?url=&prodName=&subType=Miscellaneous&locale=EN"

S="${WORKDIR}/${MY_P}"

pkg_nofetch() {
	elog "LSI has a mandatory click-through license on thier binaries."
	elog "Please visit $HOMEPAGE and download ${DISTFILE_BIN} from the Mangement Software section."
	elog "After downloading, move ${MY_P} into your DISTDIR directory"
	if use doc; then
		elog "Please also download 'SAS-3 Integrated RAID Configuration Utility User Guide' (${DISTFILE_DOC}) "
		elog "and also place it into your DISTDIR directory"
	fi
}

supportedcards() {
	elog "This binary supports should support ALL cards, including, but not"
	elog "limited to the following series:"
	elog ""
	elog "LSI SAS 3004"
	elog "LSI SAS 3008"
}

src_unpack() {
	unpack ${DISTFILE_BIN}
}

src_install() {
	exeinto /opt/lsi/
	use amd64 || use x86 && doexe sas3ircu_linux_x86_rel/sas3ircu
	use ppc64 && doexe sas3ircu_linux_x86_rel/sas3ircu
	use amd64-fbsd && doexe sas3ircu_freebsd_amd64_rel/sas3ircu
	use x86-fbsd && doexe sas3ircu_freebsd_i386_rel/sas3ircu
	use x64-solaris || use x86-solaris && doexe sas3ircu_solaris_x86_rel/sas3ircu
	use sparc-solaris && doexe sas3ircu_solaris_sparc_rel/sas3ircu
	if use efi; then
		exeinto /boot/efi/
		doexe sas3ircu_udk_uefi__x64_rel/sas3ircu.efi
	fi
	dodoc IRCU_MPT_GEN3_Phase5.0-06.00.00.00.pdf
	dodoc README_SAS3IRCU_P${PV}.txt
	use doc && dodoc "${DISTDIR}"/$DISTFILE_DOC
}
