# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="braille translator from the National Federation of the Blind"
HOMEPAGE="http://www.nfb.org/nfbtrans"
SRC_URI="http://www.nfb.org/Images/nfb/Products_Technology/nfbtr774.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

DEPEND=" >=app-arch/unzip-5.50-r2"
RDEPEND=""

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	mv MAKEFILE Makefile
	mv SPANISH.ZIP spanish.zip
	make lowercase || die
	epatch "${FILESDIR}"/${P}-gentoo-fix.patch
	epatch "${FILESDIR}"/${P}-getline-fix.patch
}

src_compile() {
	make CC=$(tc-getCC) LIBS= CFLAGS="${CFLAGS} -DLINUX" all || die
}

src_install() {
	dobin nfbtrans || die
	dodoc *fmt readme.txt makedoc
	insinto /etc/nfbtrans
	doins *cnf *tab *dic spell.dat *zip
}
