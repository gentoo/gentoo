# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit toolchain-funcs

DESCRIPTION="Linux filesystem designed to be simple, small, and to compress things well"
HOMEPAGE="https://sourceforge.net/projects/cramfs/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc ~sparc x86"
IUSE=""

DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i '1i#include <sys/sysmacros.h>' mkcramfs.c || die #580196
}

src_compile() {
	emake CFLAGS="${CFLAGS}" CC="$(tc-getCC)"
}

src_install() {
	into /
	dosbin mkcramfs cramfsck
	dodoc README NOTES
}
