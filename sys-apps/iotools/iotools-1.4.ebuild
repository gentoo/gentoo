# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/iotools/iotools-1.4.ebuild,v 1.3 2013/02/18 19:24:46 vapier Exp $

EAPI="4"

inherit eutils toolchain-funcs

DESCRIPTION="Simple commands to access hardware device registers"
HOMEPAGE="http://code.google.com/p/iotools/"
SRC_URI="http://iotools.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static make-symlinks"

src_prepare() {
	epatch "${FILESDIR}"/${P}-cpuid-pic.patch
	epatch "${FILESDIR}"/${P}-ldflags.patch
	sed -i 's:-Werror::' Makefile || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		STATIC=$(usex static 1 0) \
		IOTOOLS_DEBUG="${CFLAGS}"
}

src_install() {
	dosbin iotools

	# Note: This is done manually because invoking the iotools binary
	# when cross-compiling will likely fail.
	local known_cmds="and btr bts busy_loop cmos_read cmos_write cpu_list cpuid io_read16 io_read32 io_read8 io_write16 io_write32 io_write8 mmio_dump mmio_read16 mmio_read32 mmio_read64 mmio_read8 mmio_write16 mmio_write32 mmio_write64 mmio_write8 not or pci_list pci_read16 pci_read32 pci_read8 pci_write16 pci_write32 pci_write8 rdmsr rdtsc runon shl shr smbus_quick smbus_read16 smbus_read8 smbus_readblock smbus_receive_byte smbus_send_byte smbus_write16 smbus_write8 smbus_writeblock wrmsr xor"
	if ! tc-is-cross-compiler ; then
		local check_cmds=$(echo $(./iotools --list-cmds 2>/dev/null | grep '^  ' | LC_ALL=C sort))
		if [[ ${known_cmds} != "${check_cmds:-${known_cmds}}" ]] ; then
			eerror "known_cmds = ${known_cmds}"
			eerror "check_cmds = ${check_cmds}"
			die "need to update known_cmds cache in the ebuild"
		fi
	fi

	if use make-symlinks ; then
		local cmd
		for cmd in ${known_cmds} ; do
			dosym iotools /usr/sbin/${cmd}
		done
	fi
}
