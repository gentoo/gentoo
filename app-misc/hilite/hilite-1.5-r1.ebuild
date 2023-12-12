# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo toolchain-funcs

DESCRIPTION="Utility which highlights stderr text in red"
HOMEPAGE="https://sourceforge.net/projects/hilite"
SRC_URI="mirror://gentoo/${P}.c"
S="${WORKDIR}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ia64 ~mips ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

src_unpack() {
	cp "${DISTDIR}"/${P}.c ${P}.c || die
}

src_compile() {
	edo $(tc-getCC) ${LDFLAGS} ${CFLAGS} -o ${PN} ${P}.c || die
}

src_install() {
	dobin "${PN}"
}
