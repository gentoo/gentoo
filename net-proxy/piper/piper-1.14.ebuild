# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Piper (a tool for manipulating SOCKS5 servers)"
HOMEPAGE="http://www.qwirx.com/"
SRC_URI="http://www.qwirx.com/piper/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE=""
DEPEND=""
#RDEPEND=""

src_compile() {
	append-flags -g -Wall
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin piper
	dodoc README
}
