# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-firmware/ipxe/ipxe-1.0.0_p20120905.ebuild,v 1.6 2013/06/27 22:10:51 cardoe Exp $

EAPI=4

GIT_REV="e6427b7ee117ea4af0812bb13b57999bccd8e058"
GIT_SHORT="e6427b7"

DESCRIPTION="Open source network boot (PXE) firmware"
HOMEPAGE="http://ipxe.org"
SRC_URI="https://git.ipxe.org/ipxe.git/snapshot/${GIT_REV}.tar.bz2"

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

src_configure() {
	if use vmware; then
		sed -i config/sideband.h \
			-e 's|//#define[[:space:]]VMWARE_SETTINGS|#define VMWARE_SETTINGS|'
		sed -i config/console.h \
			-e 's|//#define[[:space:]]CONSOLE_VMWARE|#define CONSOLE_VMWARE|'
	fi
}

src_compile() {
	export NO_WERROR=1
	if use qemu; then
		emake bin/808610de.rom # pxe-e1000.rom
		emake bin/80861209.rom # pxe-eepro100.rom
		emake bin/10500940.rom # pxe-ne2k_pci.rom
		emake bin/10222000.rom # pxe-pcnet.rom
		emake bin/10ec8139.rom # pxe-rtl8139.rom
		emake bin/1af41000.rom # pxe-virtio.rom
		fi

	if use vmware; then
		emake bin/8086100f.mrom # e1000
		emake bin/808610d3.mrom # e1000e
		emake bin/10222000.mrom # vlance
		emake bin/15ad07b0.rom # vmxnet3
	fi

	use iso && emake bin/ipxe.iso
	use undi && emake bin/undionly.kpxe
	use usb && emake bin/ipxe.usb
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
