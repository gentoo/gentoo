# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="High-speed, two-pass portable 6502 cross-assembler"
HOMEPAGE="https://www.floodgap.com/retrotech/xa/"
SRC_URI="https://www.floodgap.com/retrotech/xa/dists/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"

PATCHES=(
	"${FILESDIR}"/${PN}-2.3.10-Makefile.patch
)

src_configure() {
	tc-export CC
}

src_test() {
	emake -j1 test
}

src_install() {
	emake DESTDIR="${ED}"/usr install
	einstalldocs
}
