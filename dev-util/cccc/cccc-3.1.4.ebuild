# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils toolchain-funcs

DESCRIPTION="A code counter for C and C++"
HOMEPAGE="http://cccc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc-4.7.patch

	sed -i -e "/^CFLAGS/s|=|+=|" pccts/antlr/makefile
	sed -i -e "/^CFLAGS/s|=|+=|" pccts/dlg/makefile
	sed -i -e "/^CFLAGS/s|=|+=|" \
			-e "/^LD_OFLAG/s|-o|-o |" \
			-e "/^LDFLAGS/s|=|+=|" cccc/posixgcc.mak
	#LD_OFLAG: ld on Darwin needs a space after -o
}

src_compile() {
	emake CCC="$(tc-getCXX)" LD="$(tc-getCXX)" pccts
	emake CCC="$(tc-getCXX)" LD="$(tc-getCXX)" cccc
}

src_install() {
	dodoc readme.txt changes.txt
	dohtml cccc/*.html
	cd install || die
	dodir /usr
	emake -f install.mak INSTDIR="${ED}"/usr/bin
}
