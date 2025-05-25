# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Tool for manipulating SOCKS5 servers"
HOMEPAGE="http://www.qwirx.com/"
SRC_URI="http://www.qwirx.com/piper/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

src_compile() {
	append-flags -g -Wall
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin piper
	dodoc README
}
