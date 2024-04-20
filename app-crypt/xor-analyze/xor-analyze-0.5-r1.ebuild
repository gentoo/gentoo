# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Program for cryptanalyzing xor 'encryption' with variable key length"
HOMEPAGE="https://www.habets.pp.se/synscan/programs_xor-analyze.html"
SRC_URI="https://www.habets.pp.se/synscan/files/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

src_compile() {
	rm -f Makefile || die
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" xor-analyze xor-enc
}

src_install() {
	dobin xor-analyze xor-enc
	dosym xor-enc /usr/bin/xor-dec
	dodoc README TODO
}
