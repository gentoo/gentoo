# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="High-speed, two-pass portable 6502 cross-assembler"
HOMEPAGE="https://www.floodgap.com/retrotech/xa/"
SRC_URI="https://www.floodgap.com/retrotech/${PN}/dists/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"

PATCHES=( "${FILESDIR}"/${PN}-2.3.10-fix-gcc10-fno-common.patch )

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		LD="$(tc-getCC) " \
		CFLAGS="${CFLAGS} ${LDFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_test() {
	emake -j1 test
}

src_install() {
	emake install DESTDIR="${ED}/usr"
	einstalldocs
}
