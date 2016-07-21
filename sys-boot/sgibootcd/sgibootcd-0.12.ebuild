# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
inherit eutils toolchain-funcs

DESCRIPTION="Creates burnable CD images for SGI LiveCDs"
HOMEPAGE="ftp://ftp.linux-mips.org/pub/linux/mips/people/skylark/"
SRC_URI="ftp://ftp.linux-mips.org/pub/linux/mips/people/skylark/${P}.tar.bz2"
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~mips"
IUSE=""
RDEPEND=""
DEPEND=""
RESTRICT=""

src_compile() {
	local mycc="$(tc-getCC) ${CFLAGS}"

	[ -f "${S}/sgibootcd" ] && rm -f "${S}"/sgibootcd
	einfo "${mycc} sgibootcd.c -o sgibootcd"
	${mycc} sgibootcd.c -o sgibootcd
}

src_install() {
	dobin "${S}"/sgibootcd
}
