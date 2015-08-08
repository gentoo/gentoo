# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

DESCRIPTION="a tool to create very small elf binary from pure binary files"
HOMEPAGE="http://sed.free.fr/tinlink/"
SRC_URI="http://sed.free.fr/tinlink/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
	rm -f "${S}"/Makefile
}

src_compile() {
	emake CC="$(tc-getCC)" tinlink || die
}

src_install() {
	dobin tinlink || die
	dodoc AUTHORS README example.asm
}
