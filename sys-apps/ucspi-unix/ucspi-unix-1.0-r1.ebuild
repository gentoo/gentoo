# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="UCSPI implementation for Unix domain sockets"
HOMEPAGE="https://untroubled.org/ucspi-unix/"
SRC_URI="https://untroubled.org/ucspi-unix/archive/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~loong ~riscv ~sparc ~x86"

# We statically link bglibs.
DEPEND=">=dev-libs/bglibs-2.04"

src_configure() {
	echo "$(tc-getCC) ${CFLAGS} -D_GNU_SOURCE" > conf-cc || die
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld || die
}

src_install() {
	dobin unixserver unixclient unixcat
	doman unixserver.1 unixclient.1
	dodoc NEWS PROTOCOL README
}
