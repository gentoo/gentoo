# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="program for cryptanalyzing xor 'encryption' with variable key length"
HOMEPAGE="http://www.habets.pp.se/synscan/programs.php?prog=xor-analyze"
SRC_URI="http://www.habets.pp.se/synscan/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

src_compile() {
	rm -f Makefile || die
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" xor-analyze xor-enc
}

src_install() {
	dobin xor-analyze xor-enc
	dosym xor-enc /usr/bin/xor-dec
	dodoc README TODO
}
