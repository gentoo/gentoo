# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/wscr/wscr-1.2-r1.ebuild,v 1.8 2013/02/02 17:22:42 jer Exp $

EAPI=5
inherit toolchain-funcs

DESCRIPTION="A Lightweight and Fast Anagram Solver"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="http://dev.gentoo.org/~jer/${P}.tar.gz"
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
