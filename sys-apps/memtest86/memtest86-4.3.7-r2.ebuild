# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit mount-boot toolchain-funcs

DESCRIPTION="A stand alone memory test for x86 computers"
HOMEPAGE="https://www.memtest86.com/"
SRC_URI="https://www.memtest86.com/downloads/${P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="serial"

PATCHES=(
	"${FILESDIR}"/${PN}-4.3.3-build-nopie.patch #66630 + #206726
	"${FILESDIR}"/${PN}-4.3.7-io-extern-inline.patch #548312 #568292
	"${FILESDIR}"/${PN}-4.3.7-reboot-def.patch #548312 #568292
	"${FILESDIR}"/${PN}-4.3.7-no-clean.patch #557890
)

S="${WORKDIR}/src"

BOOTDIR="/boot/memtest86"
QA_PRESTRIPPED="${BOOTDIR}/memtest"
QA_FLAGS_IGNORED="${BOOTDIR}/memtest"

src_prepare() {
	default

	sed -i -e 's,0x10000,0x100000,' memtest.lds || die

	if use serial ; then
		sed -i \
			-e '/^#define SERIAL_CONSOLE_DEFAULT/s:0:1:' \
			config.h \
			|| die "sed failed"
	fi
}

src_configure() {
	tc-export AS CC LD
}

src_test() { :; }

src_install() {
	insinto "${BOOTDIR}"
	doins memtest memtest.bin

	exeinto /etc/grub.d
	newexe "${FILESDIR}"/39_${PN}-r1 39_${PN}

	dodoc README README.build-process README.background
}

pkg_postinst() {
	mount-boot_pkg_postinst

	elog "${PN} has been installed in ${BOOTDIR}/"
	elog "You may wish to update your bootloader configs by adding these lines:"
	elog " - For grub2 just run grub-mkconfig, a configuration file is installed"
	elog "   as /etc/grub.d/39_${PN}"
	elog " - For grub legacy: (replace '?' with correct numbers for your boot partition)"
	elog "    > title=${PN}"
	elog "    > root (hd?,?)"
	elog "    > kernel ${BOOTDIR}/memtest.bin"
	elog " - For lilo:"
	elog "    > image  = ${BOOTDIR}/memtest.bin"
	elog "    > label  = ${PN}"
	elog ""
	elog "Note: For older configs, you might have to change from 'memtest' to 'memtest.bin'."
}
