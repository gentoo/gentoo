# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit mount-boot eutils toolchain-funcs

DESCRIPTION="Memory tester based on memtest86"
HOMEPAGE="http://www.memtest.org/"
SRC_URI="http://www.memtest.org/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="floppy iso serial"

BOOTDIR=/boot/memtest86plus
QA_PRESTRIPPED="${BOOTDIR}/memtest.netbsd"
QA_FLAGS_IGNORED="${BOOTDIR}/memtest.netbsd"

RDEPEND="floppy? ( >=sys-boot/grub-0.95:0 sys-fs/mtools )"
DEPEND="iso? ( app-cdr/cdrtools )"

src_prepare() {
	sed -i -e 's,0x10000,0x100000,' memtest.lds || die
	epatch "${FILESDIR}/${P}-gcc-473.patch" \
		   "${FILESDIR}/${P}-hardcoded_cc.patch"
	epatch "${FILESDIR}"/${P}-no-scp.patch
	epatch "${FILESDIR}"/${P}-io-extern-inline.patch #548312
	epatch "${FILESDIR}"/${P}-reboot-def.patch #548312
	epatch "${FILESDIR}"/${P}-no-clean.patch #557890
	epatch "${FILESDIR}"/${P}-no-C-headers.patch #592638
	epatch "${FILESDIR}"/${P}-test-random-cflags.patch #590974

	sed -i 's:genisoimage:mkisofs:' makeiso.sh || die
	if use serial ; then
		sed -i \
			-e '/^#define SERIAL_CONSOLE_DEFAULT/s:0:1:' \
			config.h \
			|| die "sed failed"
	fi
}

src_configure() {
	tc-ld-disable-gold #580212
	tc-export AS CC LD
}

src_compile() {
	emake
	if use iso ; then
		./makeiso.sh || die
	fi
}

src_test() { :; }

src_install() {
	insinto ${BOOTDIR}
	use iso && newins mt*.iso memtest.iso
	newins memtest.bin memtest
	newins memtest memtest.netbsd
	dosym memtest ${BOOTDIR}/memtest.bin

	exeinto /etc/grub.d
	doexe "${FILESDIR}"/39_memtest86+

	dodoc README README.build-process FAQ changelog

	if use floppy ; then
		dobin "${FILESDIR}"/make-memtest86+-boot-floppy
		doman "${FILESDIR}"/make-memtest86+-boot-floppy.1
	fi
}

pkg_postinst() {
	mount-boot_pkg_postinst
	elog
	elog "memtest has been installed in ${BOOTDIR}/"
	elog "You may wish to update your bootloader configs"
	elog "by adding these lines:"
	elog " - For grub2 just run grub-mkconfig, a configuration file is installed"
	elog "   as /etc/grub.d/39_${PN}"
	elog " - For grub legacy: (replace '?' with correct numbers for your boot partition)"
	elog "    > title=${PN}"
	elog "    > root (hd?,?)"
	elog "    > kernel ${BOOTDIR}/memtest"
	elog " - For lilo:"
	elog "    > image  = ${BOOTDIR}/memtest"
	elog "    > label  = ${PN}"
	elog
}
