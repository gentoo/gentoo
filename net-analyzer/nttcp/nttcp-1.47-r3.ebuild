# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Tool to test TCP and UDP throughput"
HOMEPAGE="http://www.leo.org/~elmar/nttcp/"
SRC_URI="http://www.leo.org/~elmar/nttcp/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~mips ~ppc x86"

PATCHES=(
	"${FILESDIR}"/${P}-format-security.patch
)

src_compile() {
	emake \
		ARCH= \
		CC="$(tc-getCC)" \
		LFLAGS="${LDFLAGS}" \
		OPT="${CFLAGS}"
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
}
