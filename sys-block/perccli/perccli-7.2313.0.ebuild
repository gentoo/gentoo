# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit mount-boot rpm secureboot

DESCRIPTION="LINUX PERCCLI Utility For All Dell HBA/PERC Controllers"
HOMEPAGE="https://www.dell.com/support/home/en-us/drivers/driversdetails?driverid=tdghn"
LICENSE="Dell-EULA"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="uefi"
RESTRICT="bindist fetch mirror strip"
DEPEND=""
RDEPEND=""
QA_PREBUILT="opt/MegaRAID/perccli/perccli* boot/efi/perccli.efi"

# Files not fetchable with the default user-agent, and EULA
# requires consent for redistribution.
SRC_URI="https://dl.dell.com/FOLDER09770976M/1/PERCCLI_7.2313.0_A14_Linux.tar.gz
	uefi? ( https://dl.dell.com/FOLDER09770794M/1/perccli.efi -> perccli-7.2313.0.efi )"

S=${WORKDIR}

pkg_nofetch() {
	einfo "Please download PERCCLI_7.2313.0_A14_Linux.tar.gz from"
	einfo "${HOMEPAGE}"
	einfo "and place the file in your DISTDIR directory."
	if use uefi; then
		einfo "Please download perccli.efi from"
		einfo "${HOMEPAGE}"
		einfo "and rename the file to perccli-7.2313.0.efi and place it in your DISTDIR directory."
	fi
}

pkg_setup() {
	use uefi && secureboot_pkg_setup
}

src_unpack() {
	default
	rpm_unpack ./PERCCLI*Linux/*.rpm
}

src_install() {
	exeinto /opt/MegaRAID/perccli
	doexe opt/MegaRAID/perccli/perccli64 && \
		dosym perccli64 /opt/MegaRAID/perccli/perccli
	dosym ../MegaRAID/perccli/perccli /opt/bin/perccli
	if use uefi; then
		exeinto /boot/efi
		newexe "${DISTDIR}/perccli-7.2313.0.efi" perccli.efi
	fi
	use uefi && secureboot_auto_sign --in-place
}
