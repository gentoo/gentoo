# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-boot/mbr-gpt/mbr-gpt-0.0.1.ebuild,v 1.3 2014/08/10 20:21:10 slyfox Exp $

inherit eutils flag-o-matic

DESCRIPTION="An MBR that can handle BIOS-based boot on GPT"
MY_P="${PN}_${PV}"
HOMEPAGE="http://aybabtu.com/mbr-gpt/"
SRC_URI="http://aybabtu.com/mbr-gpt/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
# This should probably NEVER go to stable. It's crazy advanced dangerous magic.
# It's also pure ASM, so not suitable for elsewhere anyway.
KEYWORDS="~x86 ~amd64"
IUSE=""
# It only depends on binutils/gcc/make, and doesn't link against libc even.
DEPEND=""
RDEPEND=""

# It's a mostly an MBR block and it does use the executable stack.
QA_WX_LOAD="usr/sbin/boot.elf"

src_unpack() {
	unpack ${A}
	cd "${S}"
	emake clean

	# Need to build it 32-bit for the MBR
	# Btw, no CFLAGS are respected, it's ASM!
	use amd64 && sed -i -e 's/-Wall/-Wall -m32/g' "${S}"/Makefile
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	# get_libdir is not correct here. We want this to go into a 32-bit library
	# location.
	insinto /usr/lib/mbr-gpt/
	doins mbr
	dosbin boot.elf
	dodoc AUTHORS
}

pkg_postinst() {
	einfo "See the instructions on the homepage, and make sure you know what"
	einfo "you are doing before touching this. The mbr file does into your"
	einfo "MBR, or alternatively you can do a creative reboot utilizing the"
	einfo "boot.elf binary."
}
