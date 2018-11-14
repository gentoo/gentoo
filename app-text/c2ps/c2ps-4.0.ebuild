# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4
inherit base toolchain-funcs

DESCRIPTION="Generates a beautified ps document from a source file (c/c++)"
HOMEPAGE="http://www.cs.technion.ac.il/users/c2ps"
SRC_URI="http://www.cs.technion.ac.il/users/c2ps/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

PATCHES=( "${FILESDIR}/${P}-LDFLAGS.patch" )

src_compile() {
	emake CC="$(tc-getCC)" CCFLAGS="${CFLAGS}"
}

src_install() {
	dodir /usr/bin /usr/share/man/man1
	emake MAN="${ED}"/usr/share/man/man1 PREFIX="${ED}"/usr install
	dodoc README
}
