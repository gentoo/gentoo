# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit mount-boot eutils toolchain-funcs

DESCRIPTION="Memory tester based on memtest86"
HOMEPAGE="http://www.memtest.org/"
SRC_URI="http://www.memtest.org/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="floppy serial"

BOOTDIR=/boot/memtest86plus
QA_PRESTRIPPED="${BOOTDIR}/memtest.netbsd"

RDEPEND="floppy? ( sys-fs/mtools )"
DEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${PN}-4.20-hardcoded_cc.patch

	sed -i -e 's,0x10000,0x100000,' memtest.lds || die

	if use serial ; then
		sed -i \
			-e '/^#define SERIAL_CONSOLE_DEFAULT/s:0:1:' \
			config.h \
			|| die "sed failed"
	fi

	cat - > "${T}"/39_${PN} <<EOF
#!/bin/sh
exec tail -n +3 \$0

menuentry "${PN} ${PV}" {
	linux16 ${BOOTDIR}/memtest
}

menuentry "${PN} ${PV} (netbsd)" {
	insmod bsd
	knetbsd ${BOOTDIR}/memtest.netbsd
}
EOF

	tc-export AS CC LD
}

src_test() { :; }

src_install() {
	insinto ${BOOTDIR}
	newins memtest.bin memtest
	newins memtest memtest.netbsd
	dosym memtest ${BOOTDIR}/memtest.bin

	exeinto /etc/grub.d
	doexe "${T}"/39_${PN}

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
