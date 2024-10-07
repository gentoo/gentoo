# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit savedconfig secureboot toolchain-funcs

# for 1.21.1_p20230601
COMMIT_SHA1="4fa4052c7ebb59e4d4aa396f1563c89118623ec7"

DESCRIPTION="Open source network boot (PXE) firmware"
HOMEPAGE="https://ipxe.org/"
SRC_URI="
	!binary? ( https://github.com/${PN}/${PN}/archive/${COMMIT_SHA1}.tar.gz -> ${P}.gh.tar.gz )
	binary? ( https://dev.gentoo.org/~tamiko/distfiles/${P}-bin.tar.xz )"
S="${WORKDIR}/${PN}-${COMMIT_SHA1}/src"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ppc64 ~riscv ~x86"
IUSE="+binary uefi32 uefi64 ipv6 iso lkrn +qemu undi usb vmware"
REQUIRED_USE="!amd64? ( !x86? ( binary ) )"

SOURCE_DEPEND="
	app-arch/xz-utils
	dev-lang/perl
	iso? (
		app-cdr/cdrtools
		sys-boot/syslinux
	)"
BDEPEND="
	!binary? (
		amd64? ( ${SOURCE_DEPEND} )
		x86? ( ${SOURCE_DEPEND} )
	)"

pkg_setup() {
	if use uefi32 || use uefi64; then
		secureboot_pkg_setup
	fi
}

src_configure() {
	use binary && return

	cat > config/local/general.h <<-EOF || die
		#undef BANNER_TIMEOUT
		#define BANNER_TIMEOUT 0
	EOF

	if use ipv6; then
		cat >> config/local/general.h <<-EOF || die
			#define NET_PROTO_IPV6
		EOF
	fi

	if use vmware; then
		cat >> config/local/general.h <<-EOF || die
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
		VERSION="${PV}" \
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
	use binary && return

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

	use uefi32 && ipxemake PLATFORM=efi BIN=bin-i386-efi bin-i386-efi/ipxe.efi
	use uefi64 && ipxemake PLATFORM=efi BIN=bin-x86_64-efi bin-x86_64-efi/ipxe.efi
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
	use uefi32 && newins bin-i386-efi/ipxe.efi ipxe-i386.efi
	use uefi64 && newins bin-x86_64-efi/ipxe.efi ipxe-x86_64.efi
	# Add a symlink for backwards compatiblity, in case both variants are
	# enabled the x86_64 bit variant takes presedence.
	use uefi32 && dosym ipxe-i386.efi /usr/share/ipxe/ipxe.efi
	use uefi64 && dosym ipxe-x86_64.efi /usr/share/ipxe/ipxe.efi

	use iso && doins bin/*.iso
	use undi && doins bin/*.kpxe
	use usb && doins bin/*.usb
	use lkrn && doins bin/*.lkrn

	if use uefi32 || use uefi64; then
		secureboot_auto_sign --in-place
	fi

	save_config config/local/general.h
}
