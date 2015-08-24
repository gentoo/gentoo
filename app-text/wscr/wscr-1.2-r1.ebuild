# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit toolchain-funcs

DESCRIPTION="A Lightweight and Fast Anagram Solver"
HOMEPAGE="https://www.gentoo.org/"
SRC_URI="https://dev.gentoo.org/~jer/${P}.tar.gz"
LICENSE="public-domain"
SLOT="0"

KEYWORDS="amd64 ~mips ppc x86"
IUSE=""
RDEPEND="sys-apps/miscfiles"

src_prepare() {
	sed -i 's#"/usr/dict/words";#"/usr/share/dict/words";#' wscr.h || die
}

src_compile() {
	emake CC="$(tc-getCC)" FLAGS="${CFLAGS} ${LDFLAGS}"
}

src_install() {
	dobin wscr
	doman wscr.6
	dodoc README
}
