# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Simple commands to access hardware device registers"
HOMEPAGE="https://code.google.com/p/iotools/"
SRC_URI="https://iotools.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc x86"
IUSE="static make-symlinks"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

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
	local known_cmds="and btr bts busy_loop cmos_read cmos_write cpu_list mem_dump mem_read16 mem_read32 mem_read64 mem_read8 mem_write16 mem_write32 mem_write64 mem_write8 mmio_dump mmio_read16 mmio_read32 mmio_read64 mmio_read8 mmio_write16 mmio_write32 mmio_write64 mmio_write8 not or pci_list pci_read16 pci_read32 pci_read8 pci_write16 pci_write32 pci_write8 runon shl shr smbus_quick smbus_read16 smbus_read8 smbus_readblock smbus_receive_byte smbus_send_byte smbus_write16 smbus_write8 smbus_writeblock xor"
	case ${ARCH} in
		amd64|x86) known_cmds+=" cpuid io_read16 io_read32 io_read8 io_write16 io_write32 io_write8 rdmsr rdtsc wrmsr";;
	esac
	if ! tc-is-cross-compiler ; then
		local sorted_cmds=$(echo $(printf '%s\n' ${known_cmds} | LC_ALL=C sort))
		local check_cmds=$(echo $(./iotools --list-cmds 2>/dev/null | grep '^  ' | LC_ALL=C sort))
		if [[ ${sorted_cmds} != "${check_cmds:-${sorted_cmds}}" ]] ; then
			eerror "known_cmds = ${sorted_cmds}"
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
