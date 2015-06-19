# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/memtest86+/memtest86+-4.00.ebuild,v 1.8 2011/01/09 03:23:16 vapier Exp $

QA_PRESTRIPPED=/boot/memtest86plus/memtest

inherit mount-boot eutils

DESCRIPTION="Memory tester based on memtest86"
HOMEPAGE="http://www.memtest.org/"
SRC_URI="http://www.memtest.org/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="floppy serial"
RESTRICT="test"

RDEPEND="floppy? ( >=sys-boot/grub-0.95 sys-fs/mtools )"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${PN}-4.00-hardcoded_cc.patch

	# Merged upstream
	#epatch "${FILESDIR}"/${PN}-1.70-gnu_hash.patch

	sed -i -e's/$(LD) -s /$(LD) /' Makefile
	sed -i -e's,0x10000,0x100000,' memtest.lds

	if use serial ; then
		sed -i -e 's/#define SERIAL_CONSOLE_DEFAULT 0/#define SERIAL_CONSOLE_DEFAULT 1/' config.h
	fi
}

src_compile() {
	emake || die
}

src_install() {
	insinto /boot/memtest86plus
	newins memtest.bin memtest || die
	newins memtest memtest.netbsd || die
	dosym memtest /boot/memtest86plus/memtest.bin
	dodoc README README.build-process

	if use floppy ; then
		dobin "${FILESDIR}"/make-memtest86+-boot-floppy
		doman "${FILESDIR}"/make-memtest86+-boot-floppy.1
	fi
}

pkg_postinst() {
	mount-boot_pkg_postinst
	einfo
	einfo "memtest has been installed in /boot/memtest86plus/"
	einfo "You may wish to update your bootloader configs"
	einfo "by adding these lines:"
	einfo " - For grub: (replace '?' with correct numbers for your boot partition)"
	einfo "    > title=Memtest86Plus"
	einfo "    > root (hd?,?)"
	einfo "    > kernel /boot/memtest86plus/memtest"
	einfo "   or try this if you get grub error 28:"
	einfo "    > title=Memtest86Plus"
	einfo "    > root (hd?,?)"
	einfo "    > kernel --type=netbsd /boot/memtest86plus/memtest.netbsd"
	einfo
	einfo " - For lilo:"
	einfo "    > image  = /boot/memtest86plus/memtest"
	einfo "    > label  = Memtest86Plus"
	einfo
}
