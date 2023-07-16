# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit mount-boot rpm secureboot

DESCRIPTION="LINUX PERCCLI Utility For All Dell HBA/PERC Controllers"
HOMEPAGE="https://www.dell.com/support/home/us/en/19/drivers/driversdetails?driverId=NF8G9"
LICENSE="Avago BSD"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="doc efi"
RESTRICT="strip"
DEPEND=""
RDEPEND=""
QA_PREBUILT="opt/MegaRAID/perccli/perccli* boot/efi/perccli.efi"

DISTFILE_DOC=dell-sas-hba-12gbps_reference-guide_en-us.pdf

SRC_URI="https://downloads.dell.com/FOLDER05235308M/1/perccli_linux_NF8G9_A07_7.529.00.tar.gz
	doc? ( https://topics-cdn.dell.com/pdf/${DISTFILE_DOC} )"

S="${WORKDIR}"/perccli_7.5-007.0529_linux

pkg_setup() {
	use efi && secureboot_pkg_setup
}

src_unpack() {
	default
	cd "${S}"
	rpm_unpack ./Linux/perccli-*.rpm
}

src_install() {
	exeinto /opt/MegaRAID/perccli/
	use amd64 && doexe opt/MegaRAID/perccli/perccli64 && \
		dosym perccli64 /opt/MegaRAID/perccli/perccli
	newexe opt/MegaRAID/perccli/perccli perccli32
	use x86 && dosym perccli32 opt/MegaRAID/perccli/perccli
	dosym ../MegaRAID/perccli/perccli /opt/bin/perccli
	use amd64 && dosym ../MegaRAID/perccli/perccli32 /opt/bin/perccli32
	if use efi; then
		exeinto /boot/efi/
		doexe EFI/perccli.efi
	fi
	use doc && dodoc "${DISTDIR}"/${DISTFILE_DOC}
	use efi && secureboot_auto_sign --in-place
}
