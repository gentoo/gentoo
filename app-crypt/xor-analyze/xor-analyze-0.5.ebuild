# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/xor-analyze/xor-analyze-0.5.ebuild,v 1.2 2011/03/21 00:11:03 vapier Exp $

inherit toolchain-funcs

DESCRIPTION="program for cryptanalyzing xor 'encryption' with variable key length"
HOMEPAGE="http://www.habets.pp.se/synscan/programs.php?prog=xor-analyze"
SRC_URI="http://www.habets.pp.se/synscan/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

src_compile() {
	rm -f Makefile
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" xor-analyze xor-enc || die
}

src_install() {
	dobin xor-analyze xor-enc || die
	dosym xor-enc /usr/bin/xor-dec
	dodoc README TODO
}
