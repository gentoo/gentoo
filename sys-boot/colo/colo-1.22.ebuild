# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-boot/colo/colo-1.22.ebuild,v 1.5 2012/05/18 14:17:11 mattst88 Exp $

inherit eutils toolchain-funcs

DESCRIPTION="CObalt LOader - Modern bootloader for Cobalt MIPS machines"
HOMEPAGE="http://www.colonel-panic.org/cobalt-mips/"
SRC_URI="http://www.colonel-panic.org/cobalt-mips/colo/colo-${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~mips"
IUSE=""
DEPEND=""
RDEPEND=""
RESTRICT="strip"

src_unpack() {
	unpack ${A}
}

src_compile() {
	echo -e ""
	einfo ">>> Building the CoLo Bootloader ..."

	# Remove -Werror from CFLAGS
	# gcc-4.3.x is more strict; We'll go back and fix later
	cd "${S}"
	for x in $(grep -rl "Werror" "${S}"/*); do
		sed -i -e 's/\-Werror//g' "${x}"
	done

	# Keep elf2rfx from automatically building via the Makefile
	sed -i -e 's/tools\/elf2rfx //' "${S}"/Makefile

	# Build it first with BUILD_CC in case of cross-compiles
	cd "${S}"/tools/elf2rfx
	make CC="$(tc-getBUILD_CC)" || die

	# Build the rest
	cd "${S}"
	make clean || die       # emake breaks the build
	make CC="$(tc-getCC)" OBJCOPY="$(tc-getOBJCOPY)" \
	     STRIP="$(tc-getSTRIP)" || die

	# Now rebuild elf2rfx again with CC so it can be installed
	cd "${S}"/tools/elf2rfx
	make clean || die
	make CC="$(tc-getCC)" || die
}

src_install() {
	# bins
	dodir /usr/lib/colo
	cp binaries/colo-chain.elf "${D}"/usr/lib/colo
	cp binaries/colo-rom-image.bin "${D}"/usr/lib/colo

	# docs
	dodoc CHANGES INSTALL README README.{restore,shell,netcon} tools/README.tools TODO

	# all tools except lcdtools (see below)
	local tool
	for tool in flash-tool colo-perm copy-rom elf2rfx; do

		einfo "Installing ${tool} binary to ${D}/usr/sbin"
		dosbin tools/${tool}/${tool}
		if [ -f tools/${tool}/${tool}.8 ]; then
			einfo "Installing ${tool} manpage to ${D}/usr/share/man"
			doman tools/flash-tool/flash-tool.8
		fi

	done

	# lcdtools
	for tool in paneld putlcd e2fsck-lcd; do
		einfo "Installing ${tool} binary and manpage to ${D}/usr/sbin"
		dosbin tools/lcdtools/${tool}/${tool}
		doman tools/lcdtools/${tool}/${tool}.8
	done
	dolib.a tools/lcdtools/liblcd/liblcd.a

	# bootscripts
	dodir /usr/lib/colo/scripts
	cp "${FILESDIR}"/*.colo "${D}"/usr/lib/colo/scripts
}

pkg_postinst() {
	echo -e ""
	einfo "Install locations:"
	einfo "   Binaries:\t/usr/lib/${PN}"
	einfo "   Docs:\t/usr/share/doc/${PF}"
	einfo "   Tools:\t/usr/sbin/{flash-tool,colo-perm,copy-rom,"
	einfo "	 \tputlcd,paneld,e2fsck-lcd,elf2rfx}"
	einfo "   Scripts:\t/usr/lib/${PN}/scripts"
	echo -e ""
	einfo "Please read the docs to fully understand the behavior of this bootloader, and"
	einfo "edit the boot scripts to suit your needs."
	echo -e ""
	ewarn "Users installing ${PN} for the first time need to be aware that newer"
	ewarn "versions of ${PN} disable the serial port by default.  If the serial port"
	ewarn "is needed, select it from the boot menu.  Users using the example boot"
	ewarn "scripts provided will have the serial port automatically enabled."
	echo -e ""
	ewarn "Note: It is HIGHLY recommended that you use the chain"
	ewarn "bootloader (colo-chain.elf) first before attempting to"
	ewarn "write the bootloader to the flash chip to verify that"
	ewarn "it will work for you.  It is also recommended that"
	ewarn "you read the documentation in /usr/share/doc/${PF}"
	ewarn "as it explains how to properly use this package."
	echo -e ""
	eerror "Warning: Make sure that IF you plan on flashing the"
	eerror "bootloader into the flash chip that you are using a"
	eerror "modern 2.4 Linux kernel (i.e., >2.4.18), otherwise"
	eerror "you run a risk of destroying the contents of the"
	eerror "flash chip and rendering the machine unusable."
	echo -e ""
	echo -e ""
}
