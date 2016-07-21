# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

DESCRIPTION="Turn English phrases to C or C++ declarations"
SRC_URI="ftp://ftp.netsw.org/softeng/lang/c/tools/cdecl/${P}.tar.gz"
HOMEPAGE="http://www.boutell.com/lsm/lsmbyid.cgi/002103"

KEYWORDS="amd64 ~mips ppc x86"
LICENSE="public-domain"
SLOT="0"

RDEPEND="readline? (
			sys-libs/ncurses
			sys-libs/readline
			)"

DEPEND="${RDEPEND}
		|| (
			dev-util/yacc
			sys-devel/bison
			)
		!<dev-util/cutils-1.6-r2"

IUSE="readline"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}.patch"
	epatch "${FILESDIR}/${P}-implicit-pointer.patch"
}

src_compile() {
	if use readline; then
		CFLAGS="${CFLAGS} -DUSE_READLINE"
		LIBS="${LIBS} -lreadline -lncurses"
	fi
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" LIBS="${LIBS}" || die
}

src_install() {
	dobin cdecl
	dohard /usr/bin/cdecl /usr/bin/c++decl
	dodoc README
	doman *.1
}
