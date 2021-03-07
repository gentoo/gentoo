# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="CmosPwd decrypts password stored in cmos used to access BIOS SETUP"
HOMEPAGE="https://www.cgsecurity.org/wiki/CmosPwd"
SRC_URI="https://www.cgsecurity.org/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

src_compile() {
	cd src || die
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} cmospwd.c -o cmospwd || die
}

src_install() {
	dosbin src/cmospwd
	dodoc cmospwd.txt
}
