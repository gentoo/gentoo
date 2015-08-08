# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs versionator

# Hack until upstream renames from 0.5 to 0.50
MY_PV="${PV/50/5}"

PATCHREV="1"
DESCRIPTION="ARCLoad - SGI Multi-bootloader.  Able to bootload many different SGI Systems"
HOMEPAGE="http://www.linux-mips.org/wiki/index.php/ARCLoad"
SRC_URI="ftp://ftp.linux-mips.org/pub/linux/mips/people/skylark/${PN}-${MY_PV}.tar.bz2
	 mirror://gentoo/${P}-patches-v${PATCHREV}.tar.xz"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="-* ~mips"
IUSE=""
DEPEND="sys-boot/dvhtool
	abi_mips_o32? ( sys-devel/kgcc64 )"
RDEPEND=""
RESTRICT="strip"

S="${WORKDIR}/${PN}-${MY_PV}"
PATCHDIR="${WORKDIR}/${P}-patches"

src_prepare() {
	# For gcc-4.x, quiet down some of the warnings
	epatch "${PATCHDIR}"/${P}-shut-gcc4x-up.patch

	# Redefine the targets in the primary Makefile to give us
	# finer control over building the tools.  This is for properly
	# cross-compiling arcload
	epatch "${PATCHDIR}"/${P}-makefile-targets.patch

	# Patches borrowed from Debian:
	# - Load ELF64 images on 32-bit systems - XXX: #543978
	# - Pass an arcload label name directly on the PROM cmdline.
	# - Look for arc.cf in /etc and fallback to /.
#	epatch "${PATCHDIR}"/${P}_deb-elf64-on-m32.patch
	epatch "${PATCHDIR}"/${P}_deb-cmdline-config.patch
	epatch "${PATCHDIR}"/${P}_deb-config-in-etc.patch

	# Building arcload on different MIPS ABIs can be difficult,
	# so we include specific bits from standard system headers
	# to make the compiler happy.  These should rarely, if ever,
	# change...
	epatch "${PATCHDIR}"/${P}-local-elf_h.patch

	# Patch wreckoff.c to handle the new .MIPS.abiflags section.
	epatch "${PATCHDIR}"/${P}-wreckoff-abiflags-fix.patch

	# In order to convert from ELF to ECOFF, we need to disable
	# SSP, as that adds additional program headers that I don't
	# know how to handle in wreckoff.c.
	epatch "${PATCHDIR}"/${P}-disable-ssp.patch

	# The code is old and has a lot of issues.  But it's just a
	# simple bootloader, so silence the various warnings until
	# it can be re-written.
	epatch "${PATCHDIR}"/${P}-silence-warnings.patch
}

src_compile() {
	local myCC myCC64 myLD myLD64

	myCC="$(tc-getCC)"
	myLD="$(tc-getLD)"
	if use abi_mips_o32; then
		myCC64=${myCC/mips/mips64}
		myLD64=${myLD/mips/mips64}
	else
		myCC64=${myCC}
		myLD64=${myLD}
	fi

	# Build the wreckoff tool first.  It converts a 32bit MIPS ELF
	# into a relocatable ECOFF image.  We call for BUILD_CC
	# on the offchance that we're cross-compiling.
	echo -e ""
	einfo ">>> Building the 'wreckoff' utility with $(tc-getBUILD_CC) ..."
	emake CC=$(tc-getBUILD_CC) tools_clean tools

	# 32bit copy (sashARCS for IP22/IP32)
	echo -e ""
	einfo ">>> Building 32-bit version (sashARCS) for IP22/IP32 with ${myCC} ..."
	cd "${S}"
	emake MODE=M32 bootloader_clean
	emake CC=${myCC} LD=${myLD} MODE=M32 bootloader
	cp "${S}"/arcload.ecoff "${WORKDIR}"/sashARCS

	# 64bit copy (sash64 for IP27/IP28/IP30)
	echo -e ""
	einfo ">>> Building 64-bit version (sash64) for IP27/IP28/IP30 ${myCC/mips/mips64} ..."
	emake MODE=M64 bootloader_clean
	emake CC=${myCC64} LD=${myLD64} MODE=M64 bootloader
	cp "${S}"/arcload "${WORKDIR}"/sash64
}

src_install() {
	dodir /usr/lib/arcload
	cp "${WORKDIR}"/sashARCS "${D}"/usr/lib/arcload
	cp "${WORKDIR}"/sash64 "${D}"/usr/lib/arcload
	cp "${S}"/arc.cf-bootcd "${D}"/usr/lib/arcload/arc-bootcd.cf
	cp "${S}"/arc.cf-octane "${D}"/usr/lib/arcload/arc-octane.cf

	# Add a manpage for arcload(8) from the Debian Project.
	doman "${FILESDIR}/arcload.8"
}

pkg_postinst() {
	echo -e ""
	einfo "ARCLoad binaries copied to: /usr/lib/arcload"
	echo -e ""
	einfo "Use of ARCLoad is relatively easy:"
	einfo "\t1) Determine which version you need"
	einfo "\t\tA) sashARCS for IP22/IP32"
	einfo "\t\tB) sash64 for IP27/IP28/IP30"
	einfo "\t2) Copy that to the volume header using 'dvhtool'"
	einfo "\t3) Edit /usr/lib/arcload/arc-*.cf to fit your specific system"
	einfo "\t   (See ${HOMEPAGE} for"
	einfo "\t    an explanation of the format of the config file)"
	einfo "\t4) Copy the config file to the volume header with 'dvhtool' as 'arc.cf'"
	einfo "\t5) Copy any kernels to the volume header that you want to be bootable"
	einfo "\t6) Reboot, and enjoy!"
	echo -e ""
}
