# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit mount-boot

DESCRIPTION="LSI MPT-SAS2 controller management tool"
HOMEPAGE="http://www.lsi.com/support/Pages/download-results.aspx?component=Storage+Component&productfamily=Host+Bus+Adapters&productcode=0&assettype=Miscellaneous&productname=&keyword=SAS2IRCU"
LICENSE="LSI"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86 ~x86-fbsd ~ppc64 ~amd64-fbsd ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="efi doc"
RESTRICT="strip fetch mirror"
DEPEND=""
RDEPEND=""
QA_PREBUILT="opt/lsi/sas2ircu boot/efi/sas2ircu.efi"

MY_PN=SAS2IRCU
MY_P="${MY_PN}_P${PV}"

DISTFILE_BIN=${MY_P}.zip
DISTFILE_DOC=SAS2IRCU_User_Guide.pdf
DOC_PV=12

SRC_URI="
http://www.lsi.com/downloads/Public/Host%20Bus%20Adapters/Host%20Bus%20Adapters%20Common%20Files/SAS_SATA_6G_P${PV}/$DISTFILE_BIN
doc? ( http://www.lsi.com/downloads/Public/Host%20Bus%20Adapters/Host%20Bus%20Adapters%20Common%20Files/SAS_SATA_6G_P${DOC_PV}/SAS2IRCU_User_Guide.pdf )
"

LICENSE_URL="http://www.lsi.com/cm/License.do?url=&prodName=&subType=Miscellaneous&locale=EN"

S="${WORKDIR}/${MY_P}"

pkg_nofetch() {
	elog "LSI has a mandatory click-through license on thier binaries."
	elog "Please visit $HOMEPAGE and download ${DISTFILE_BIN} from the Miscellaneous section."
	elog "After downloading, move ${MY_P} into $DISTDIR"
	if use doc; then
		elog "Please also download 'SAS-2 Integrated RAID Configuration Utility User Guide' (${DISTFILE_DOC}) "
		elog "and also place it into $DISTDIR"
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
	use amd64-fbsd && doexe sas2ircu_freebsd_amd64_rel/sas2ircu
	use x86-fbsd && doexe sas2ircu_freebsd_i386_rel/sas2ircu
	use x64-solaris || use x86-solaris && doexe sas2ircu_solaris_x86_rel/sas2ircu
	use sparc-solaris && doexe sas2ircu_solaris_sparc_rel/sas2ircu
	if use efi; then
		exeinto /boot/efi/
		doexe sas2ircu_efi_ebc_rel/sas2ircu.efi
	fi
	dodoc Readme_Release_Notes_SAS2IRCU_Phase_17.00.00.00.txt
	dodoc SAS2IRCU_Phase${PV}.0-${PV}.00.00.00.pdf
	use doc && dodoc "${DISTDIR}"/$DISTFILE_DOC
}
