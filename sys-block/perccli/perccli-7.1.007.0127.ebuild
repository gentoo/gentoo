# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit mount-boot rpm

DESCRIPTION="LINUX PERCCLI Utility For All PERC Controllers"
HOMEPAGE="http://www.dell.com/support/home/us/en/04/drivers/driversdetails?driverId=F48C2"
LICENSE="Avago BSD"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="efi doc"
RESTRICT="strip"
DEPEND=""
RDEPEND=""
QA_PREBUILT="opt/MegaRAID/perccli/perccli* boot/efi/perccli.efi"

DISTFILE_DOC=poweredge-rc-h730_reference%20guide_en-us.pdf

SRC_URI="https://downloads.dell.com/FOLDER04470715M/1/perccli_7.1-007.0127_linux.tar.gz
	doc? ( http://topics-cdn.dell.com/pdf/poweredge-rc-h730_reference%20guide_en-us.pdf )"

S="${WORKDIR}"

src_unpack() {
	default
	rpm_unpack ./Linux/perccli-*.rpm
}

src_install() {
	exeinto /opt/MegaRAID/perccli/
	use amd64 && doexe opt/MegaRAID/perccli/perccli64 && \
		dosym perccli64 /opt/MegaRAID/perccli/perccli
	use x86 && doexe opt/MegaRAID/perccli/perccli
	if use efi; then
		exeinto /boot/efi/
		doexe EFI/perccli.efi
	fi
	use doc && dodoc "${DISTDIR}"/${DISTFILE_DOC}
}
