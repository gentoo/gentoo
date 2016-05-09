# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A utility which highlights stderr text in red"
HOMEPAGE="http://sourceforge.net/projects/hilite"
SRC_URI="mirror://gentoo/${P}.c"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~mips ~ppc ~sparc ~x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

S="${WORKDIR}"

src_unpack() { :; }

src_prepare() {
	default
	cp "${DISTDIR}"/${P}.c "${WORKDIR}"/ || die
}

src_compile() {
	ebegin "$(tc-getCC) ${LDFLAGS} ${CFLAGS} -o ${PN} ${P}.c"
	$(tc-getCC) ${LDFLAGS} ${CFLAGS} -o ${PN} ${P}.c || die
	eend $?
}

src_install() {
	dobin "${PN}"
}
