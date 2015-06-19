# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/nfbtrans/nfbtrans-7.74-r1.ebuild,v 1.4 2013/04/21 19:30:48 williamh Exp $

EAPI="3"

inherit eutils

DESCRIPTION="braille translator from the National Federation of the Blind"
HOMEPAGE="http://www.nfb.org/nfbtrans"
SRC_URI="http://www.nfb.org/Images/nfb/Products_Technology/nfbtr774.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND=" >=app-arch/unzip-5.50-r2"
RDEPEND=""

S=${WORKDIR}

src_prepare() {
	mv MAKEFILE Makefile
	mv SPANISH.ZIP spanish.zip
	make lowercase || die
	epatch "${FILESDIR}"/${P}-gentoo-fix.patch
	epatch "${FILESDIR}"/${P}-getline-fix.patch
}

src_compile() {
	make CC=$(tc-getCC) \
		LIBS= \
		CFLAGS="${CFLAGS} -DLINUX" LDFLAGS="${LDFLAGS}" all || die
}

src_install() {
	dobin nfbtrans || die
	dodoc *fmt readme.txt makedoc
	insinto /etc/nfbtrans
	doins *cnf *tab *dic spell.dat *zip
}
