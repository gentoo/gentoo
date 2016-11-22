# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit toolchain-funcs eutils savedconfig

GIT_REV="694c18addc0dfdf51369f6d598dd0c8ca4bf2861"
GIT_SHORT=${GIT_REV:0:7}

DESCRIPTION="Open source network boot (PXE) firmware"
HOMEPAGE="http://ipxe.org/"
SRC_URI="https://git.ipxe.org/ipxe.git/snapshot/${GIT_REV}.tar.bz2 -> ${P}-${GIT_SHORT}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
# TODO: Add arm/arm64 once figure out how to build w/out including
# all the x86-specific drivers (that use I/O insns).
KEYWORDS="-* ~amd64 ~x86"
IUSE="efi ipv6 iso lkrn +qemu undi usb vmware"

DEPEND="app-arch/xz-utils
	dev-lang/perl
	sys-libs/zlib
	iso? (
		sys-boot/syslinux
		virtual/cdrtools
	)"
RDEPEND=""

S="${WORKDIR}/ipxe-${GIT_SHORT}/src"

src_prepare() {
	epatch "${FILESDIR}"/${P}-no-pie.patch #585752
}

src_configure() {
	cat <<-EOF > "${S}"/config/local/general.h
#undef BANNER_TIMEOUT
#define BANNER_TIMEOUT 0
EOF

	use ipv6 && echo "#define NET_PROTO_IPV6" >> "${S}"/config/local/general.h

	if use vmware; then
		cat <<-EOF >> "${S}"/config/local/general.h
#define VMWARE_SETTINGS
#define CONSOLE_VMWARE
EOF
	fi

	restore_config config/local/general.h

	tc-ld-disable-gold
}

ipxemake() {
	# Q='' makes the build verbose since that's what everyone loves now
	emake Q='' \
		CC="$(tc-getCC)" \
		LD="$(tc-getLD)" \
		AS="$(tc-getAS)" \
		AR="$(tc-getAR)" \
		NM="$(tc-getNM)" \
		OBJCOPY="$(tc-getOBJCOPY)" \
		RANLIB="$(tc-getRANLIB)" \
		OBJDUMP="$(tc-getOBJDUMP)" \
		HOST_CC="$(tc-getBUILD_CC)" \
		"$@"
}

src_compile() {
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

	use efi && ipxemake PLATFORM=efi BIN=bin-efi bin-efi/ipxe.efi
	use iso && ipxemake bin/ipxe.iso
	use undi && ipxemake bin/undionly.kpxe
	use usb && ipxemake bin/ipxe.usb
	use lkrn && ipxemake bin/ipxe.lkrn
}

src_install() {
	insinto /usr/share/ipxe/

	if use qemu || use vmware; then
		doins bin/*.rom
	fi
	use vmware && doins bin/*.mrom
	use efi && doins bin-efi/*.efi
	use iso && doins bin/*.iso
	use undi && doins bin/*.kpxe
	use usb && doins bin/*.usb
	use lkrn && doins bin/*.lkrn

	save_config config/local/general.h
}
