# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Mac/PowerMac disk partitioning utility"
HOMEPAGE="ftp://ftp.mklinux.apple.com/pub/Other_Tools/"
SRC_URI="
	mirror://debian/pool/main/m/mac-fdisk/${PN}_${PV/_p*}.orig.tar.gz
	mirror://debian/pool/main/m/mac-fdisk/${PN}_${PV/_p*}-${PV/*_p}.diff.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

S=${WORKDIR}/${P/_p*}.orig
PATCHES=(
	"${WORKDIR}"/${PN}_${PV/_p*}-${PV/*_p}.diff
	"${FILESDIR}"/largerthan2gb.patch
	"${FILESDIR}"/${PN}-0.1-headers.patch
	# Patch for bug #142737
	"${FILESDIR}"/${PN}-0.1_p16-ppc64.patch
	### Patch for building on amd64
	"${FILESDIR}"/${PN}-amd64.patch
	# Patch for large (>550GB disks)
	# Note that >=2TB disks may not work due to limitations of the Mac
	# Partition Table structure, this needs to be investigated
	"${FILESDIR}"/big_pt.patch
	"${FILESDIR}"/${PN}-0.1_p16-ppc-inline.patch
	"${FILESDIR}"/${PN}-0.1_p18-lseek64.patch
)

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	into /
	newsbin pdisk mac-fdisk
	newsbin fdisk pmac-fdisk

	into /usr
	newman mac-fdisk.8.in mac-fdisk.8
	newman pmac-fdisk.8.in pmac-fdisk.8

	dodoc debian/changelog README HISTORY
}
