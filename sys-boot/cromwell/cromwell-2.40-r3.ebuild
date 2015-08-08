# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils mount-boot toolchain-funcs flag-o-matic

DESCRIPTION="Xbox boot loader"
HOMEPAGE="http://www.xbox-linux.org/wiki/Cromwell"
SRC_URI="mirror://gentoo/${P}.tar.bz2
	mirror://gentoo/${PF}-cvs-fixes.patch.lzma"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* x86"
IUSE=""
RESTRICT="strip"

src_prepare() {
	epatch "${WORKDIR}"/${PF}-cvs-fixes.patch
	epatch "${FILESDIR}"/${P}-gcc-4.6.patch #363535
	sed -i 's:-Werror:-m32:' Makefile Rules.make || die
	sed -i '/^EXTRA_CFLAGS/s:$: -m32:' Rules.make boot_rom/Makefile || die
	sed -i \
		-e '/^bin.imagebld:/,$s:\<gcc\>:${CC}:' \
		Makefile || die
	append-flags -m32
}

src_compile() {
	emake -j1 CC="$(tc-getCC)" LD="$(tc-getLD)"
}

src_install() {
	insinto /boot/${PN}
	doins image/cromwell{,_1024}.bin xbe/xromwell.xbe
}
