# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-boot/cromwell/cromwell-2.40-r3.ebuild,v 1.7 2012/05/13 20:46:13 vapier Exp $

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
