# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-firmware/ipxe/ipxe-1.0.0_p20130624.ebuild,v 1.9 2015/03/16 21:25:47 vapier Exp $

EAPI=5

inherit toolchain-funcs

GIT_REV="936134ed460618e18cc05d677a442d43d5e739a1"
GIT_SHORT="936134e"

DESCRIPTION="Open source network boot (PXE) firmware"
HOMEPAGE="http://ipxe.org"
SRC_URI="https://git.ipxe.org/ipxe.git/snapshot/${GIT_REV}.tar.bz2 -> ${P}-${GIT_SHORT}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="iso +qemu undi usb vmware"

DEPEND="sys-devel/make
	dev-lang/perl
	sys-libs/zlib
	iso? (
		sys-boot/syslinux
		virtual/cdrtools
	)"
RDEPEND=""

S="${WORKDIR}/ipxe-${GIT_SHORT}/src"

src_prepare() {
	cat <<-EOF > "${S}"/config/local/general.h
#undef BANNER_TIMEOUT
#define BANNER_TIMEOUT 0
EOF

	if use vmware; then
		cat <<-EOF >> "${S}"/config/local/general.h
#define VMWARE_SETTINGS
#define CONSOLE_VMWARE
EOF
	fi
}

src_compile() {
	tc-ld-disable-gold
	ipxemake() {
		# Q='' makes the build verbose since that's what everyone loves now
		emake Q='' \
			CC=$(tc-getCC) \
			LD="$(tc-getLD)" \
			AR=$(tc-getAR) \
			OBJCOPY=$(tc-getOBJCOPY) \
			RANLIB=$(tc-getRANLIB) \
			OBJDUMP=$(tc-getPROG OBJDUMP objdump) \
			HOST_CC=$(tc-getBUILD_CC) \
			${*}
	}

	export NO_WERROR=1
	if use qemu; then
		ipxemake bin/808610de.rom # pxe-e1000.rom (old)
		ipxemake bin/8086100e.rom # pxe-e1000.rom
		ipxemake bin/80861209.rom # pxe-eepro100.rom
		ipxemake bin/10500940.rom # pxe-ne2k_pci.rom
		ipxemake bin/10222000.rom # pxe-pcnet.rom
		ipxemake bin/10ec8139.rom # pxe-rtl8139.rom
		ipxemake bin/1af41000.rom # pxe-virtio.rom
		fi

	if use vmware; then
		ipxemake bin/8086100f.mrom # e1000
		ipxemake bin/808610d3.mrom # e1000e
		ipxemake bin/10222000.mrom # vlance
		ipxemake bin/15ad07b0.rom # vmxnet3
	fi

	use iso && ipxemake bin/ipxe.iso
	use undi && ipxemake bin/undionly.kpxe
	use usb && ipxemake bin/ipxe.usb
}

src_install() {
	insinto /usr/share/ipxe/

	if use qemu || use vmware; then
		doins bin/*.rom
	fi
	use vmware && doins bin/*.mrom
	use iso && doins bin/*.iso
	use undi && doins bin/*.kpxe
	use usb && doins bin/*.usb
}
