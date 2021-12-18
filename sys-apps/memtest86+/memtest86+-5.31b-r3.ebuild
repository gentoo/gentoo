# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mount-boot toolchain-funcs

DESCRIPTION="Memory tester based on memtest86"
HOMEPAGE="http://www.memtest.org/"
SRC_URI="http://www.memtest.org/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="+boot floppy iso serial"

BOOTDIR="/boot/memtest86plus"
QA_PRESTRIPPED="${BOOTDIR#/}/memtest usr/share/${PN}/memtest"
QA_FLAGS_IGNORED="${BOOTDIR#/}/memtest usr/share/${PN}/memtest"

RDEPEND="floppy? ( sys-fs/mtools )"
DEPEND="${RDEPEND}"
BDEPEND="iso? ( app-cdr/cdrtools )"

PATCHES=(
	"${FILESDIR}/${P}-gcc-473.patch"
	"${FILESDIR}/${P}-hardcoded_cc.patch"
	"${FILESDIR}/${P}-no-clean.patch" #557890
	"${FILESDIR}/${P}-objcopy.patch"
	"${FILESDIR}/${P}-test-random-cflags.patch" #590974
	"${FILESDIR}/${P}-fix-gcc8-freeze-crash.patch"
	"${FILESDIR}/${P}-discard-note_gnu_property.patch"
)

pkg_pretend() {
	use boot && mount-boot_pkg_pretend
}

src_prepare() {
	sed -i -e 's,0x10000,0x100000,' memtest.lds || die
	sed -i 's:genisoimage:mkisofs:' makeiso.sh || die

	if use serial ; then
		sed -i -e '/^#define SERIAL_CONSOLE_DEFAULT/s:0:1:' \
			config.h || die "sed failed"
	fi
	#613196
	use amd64 && sed -i -e's,$(LD) -s -T memtest.lds,$(LD) -s -T memtest.lds -z max-page-size=0x1000,' Makefile
	default
}

src_configure() {
	tc-ld-disable-gold #580212
	tc-export AS CC LD
}

src_compile() {
	emake OBJCOPY="$(tc-getOBJCOPY)"
	if use iso ; then
		./makeiso.sh || die
	fi
}

src_test() { :; }

src_install() {
	if use boot ; then
		insinto "${BOOTDIR}"
		doins memtest memtest.bin
	fi

	insinto /usr/share/${PN}
	use iso && newins mt*.iso memtest.iso
	doins memtest memtest.bin

	exeinto /etc/grub.d
	newexe "${FILESDIR}"/39_${PN}-r1 39_${PN}

	dodoc README README.build-process FAQ changelog

	if use floppy ; then
		dobin "${FILESDIR}"/make-memtest86+-boot-floppy
		doman "${FILESDIR}"/make-memtest86+-boot-floppy.1
	fi
}

pkg_preinst() {
	use boot && mount-boot_pkg_preinst
}

pkg_postinst() {
	if use boot; then
		mount-boot_pkg_postinst

		elog "memtest86+ has been installed in ${BOOTDIR}/"
		elog "You may wish to update your bootloader configs:"
		elog " - For grub2 just re-run grub-mkconfig -o /boot/grub/grub.cfg, since a"
		elog "   config generator has been installed at /etc/grub.d/39_${PN}"
		elog " - For lilo, add the following to /etc/lilo.conf and re-run lilo:"
		elog "    > image  = ${BOOTDIR}/memtest.bin"
		elog "    > label  = ${PN}"
		elog ""
		elog "Note: For older configs, you might have to change from 'memtest' to 'memtest.bin'."
	fi

	if use boot && [ -e /sys/firmware/efi ]; then
		ewarn "WARNING: You appear to be booted in EFI mode but ${PN} is a BIOS-only tool."
	fi
}

pkg_prerm() {
	use boot && mount-boot_pkg_prerm
}

pkg_postrm() {
	use boot && mount-boot_pkg_postrm
}
