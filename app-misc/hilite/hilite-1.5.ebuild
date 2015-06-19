# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/hilite/hilite-1.5.ebuild,v 1.19 2011/01/05 15:28:42 jlec Exp $

inherit toolchain-funcs

DESCRIPTION="A utility which highlights stderr text in red"
HOMEPAGE="http://sourceforge.net/projects/hilite"
SRC_URI="mirror://gentoo/${P}.c"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ia64 ~mips ppc sparc x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}"/${A} "${WORKDIR}"/
}

src_compile() {
	einfo "$(tc-getCC) ${LDFLAGS} ${CFLAGS} -o ${PN} ${P}.c"
	$(tc-getCC) ${LDFLAGS} ${CFLAGS} -o ${PN} ${P}.c || die
}

src_install() {
	dobin hilite || die
}
