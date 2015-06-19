# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-boot/arcload/arcload-0.50-r1.ebuild,v 1.8 2015/03/21 18:22:44 kumba Exp $

EAPI=4

inherit eutils toolchain-funcs versionator

# Hack until upstream renames from 0.5 to 0.50
MY_PV="${PV/50/5}"

DESCRIPTION="ARCLoad - SGI Multi-bootloader.  Able to bootload many different SGI Systems"
HOMEPAGE="http://www.linux-mips.org/wiki/index.php/ARCLoad"
SRC_URI="ftp://ftp.linux-mips.org/pub/linux/mips/people/skylark/${PN}-${MY_PV}.tar.bz2"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="-* ~mips"
IUSE=""
DEPEND="sys-boot/dvhtool"
RDEPEND=""
RESTRICT="strip"

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	# For gcc-4.x, quiet down some of the warnings
	$(version_is_at_least "4.0" "$(gcc-version)") && \
		epatch "${FILESDIR}"/${P}-shut-gcc4x-up.patch

	# Redefine the targets in the primary Makefile to give us
	# finer control over building the tools.  This is for properly
	# cross-compiling arcload
	epatch "${FILESDIR}"/${P}-makefile-targets.patch
}

src_compile() {
	# Build the wreckoff tool first.  It converts a 32bit MIPS ELF
	# into a relocatable ECOFF image.  We call for BUILD_CC
	# on the offchance that we're cross-compiling.
	echo -e ""
	einfo ">>> Building the 'wreckoff' utility with $(tc-getBUILD_CC) ..."
	emake CC=$(tc-getBUILD_CC) tools_clean tools

	# 32bit copy (sashARCS for IP22/IP32)
	echo -e ""
	einfo ">>> Building 32-bit version (sashARCS) for IP22/IP32 ..."
	cd "${S}"
	emake MODE=M32 bootloader_clean
	emake CC=$(tc-getCC) LD=$(tc-getLD) MODE=M32 bootloader
	cp "${S}"/arcload.ecoff "${WORKDIR}"/sashARCS

	# 64bit copy (sash64 for IP27/IP28/IP30)
	echo -e ""
	einfo ">>> Building 64-bit version (sash64) for IP27/IP28/IP30 ..."
	emake MODE=M64 bootloader_clean
	emake CC=$(tc-getCC) LD=$(tc-getLD) MODE=M64 bootloader
	cp "${S}"/arcload "${WORKDIR}"/sash64
}

src_install() {
	dodir /usr/lib/arcload
	cp "${WORKDIR}"/sashARCS "${D}"/usr/lib/arcload
	cp "${WORKDIR}"/sash64 "${D}"/usr/lib/arcload
	cp "${S}"/arc.cf-bootcd "${D}"/usr/lib/arcload/arc-bootcd.cf
	cp "${S}"/arc.cf-octane "${D}"/usr/lib/arcload/arc-octane.cf
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
