# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/erec/erec-2.2.0.1.ebuild,v 1.12 2009/09/23 14:28:25 ssuominen Exp $

inherit eutils toolchain-funcs

DESCRIPTION="A shared audio recording server"
HOMEPAGE="http://bisqwit.iki.fi/source/erec.html"
SRC_URI="http://bisqwit.iki.fi/src/arch/${P}.tar.bz2"

KEYWORDS="amd64 ~ppc sparc x86"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="sys-apps/sed"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i \
		-e "s:BINDIR=/usr/local/bin:BINDIR=${D}usr/bin:" \
		-e "s:^\\(ARGHLINK.*-L.*\\):#\\1:" \
		-e "s:^#\\(ARGHLINK=.*a\\)$:\\1:" \
		-e "s:\$(CXX):\$(CXX) \$(CXXFLAGS) -I\"${S}\"/argh:g" \
		Makefile

	sed -i \
		 -e "s:CPPFLAGS=:CPPFLAGS=-I\"${S}\"/argh :" \
		Makefile.sets

	echo "" > .depend
	echo "" > argh/.depend
	epatch "${FILESDIR}/${P}-gcc43.patch"
}

src_compile() {
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" CXXFLAGS="${CXXFLAGS}" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" -j1 || die
}

src_install() {
	dobin erec || die
	dodoc README
	dohtml README.html
}
