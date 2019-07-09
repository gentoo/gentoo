# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils flag-o-matic

DESCRIPTION="An MBR that can handle BIOS-based boot on GPT"
MY_P="${PN}_${PV}"
HOMEPAGE="https://web.archive.org/web/20080704173538/http://aybabtu.com/mbr-gpt/"
SRC_URI="https://dev.gentoo.org/~robbat2/distfiles/${MY_P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
# This should probably NEVER go to stable. It's crazy advanced dangerous magic.
# It's also pure ASM, so not suitable for elsewhere anyway.
# Please don't remove it, robbat2 has a box that depends on it for # booting!
KEYWORDS="~amd64 ~x86"
IUSE=""
# It only depends on binutils/gcc/make, and doesn't link against libc even.
DEPEND=""
RDEPEND=""

# It's a mostly an MBR block and it does use the executable stack.
QA_WX_LOAD="usr/lib/$PN/boot.elf"
QA_PRESTRIPPED="${QA_WX_LOAD}"
QA_FLAGS_IGNORED="${QA_WX_LOAD}"

# Don't strip it either; this binary reboots your host!
RESTRICT="binchecks strip"

src_prepare() {
	default
	# Messy upstream
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
	insinto /usr/lib/$PN
	doins mbr
	exeinto /usr/lib/$PN
	exeopts -m 700
	doexe boot.elf
	dodoc AUTHORS
}

pkg_postinst() {
	einfo "See the instructions on the homepage, and make sure you know what"
	einfo "you are doing before touching this. The mbr file does into your"
	einfo "MBR, or alternatively you can do a creative reboot utilizing the"
	einfo "boot.elf binary."
}
