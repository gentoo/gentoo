# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="all-in-one SFV checksum utility"
HOMEPAGE="http://bsdsfv.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ~m68k ppc ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

S=${WORKDIR}/${PN}

PATCHES=( "${FILESDIR}"/${P}-64bit.patch )

src_compile() {
	emake STRIP=true CC=$(tc-getCC)
}

src_install() {
	dobin bsdsfv
	dodoc README MANUAL
}
