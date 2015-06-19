# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-proxy/piper/piper-1.14.ebuild,v 1.1 2006/11/12 02:00:29 robbat2 Exp $

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
