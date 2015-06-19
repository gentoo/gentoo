# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/tinlink/tinlink-1.0.0.ebuild,v 1.3 2009/08/01 01:33:56 vostorga Exp $

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
