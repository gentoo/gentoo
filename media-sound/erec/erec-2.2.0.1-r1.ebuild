# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Shared audio recording server"
HOMEPAGE="https://bisqwit.iki.fi/source/erec.html"
SRC_URI="https://bisqwit.iki.fi/src/arch/${P}.tar.bz2"

KEYWORDS="amd64 ~ppc sparc x86"
LICENSE="GPL-2+"
SLOT="0"

PATCHES=( "${FILESDIR}/${P}-gcc43.patch" )

DOCS=( README )
HTML_DOCS=( README.html )

src_prepare() {
	sed -i \
		-e "s:BINDIR=/usr/local/bin:BINDIR=${D}/usr/bin:" \
		-e "s:^\\(ARGHLINK.*-L.*\\):#\\1:" \
		-e "s:^#\\(ARGHLINK=.*a\\)$:\\1:" \
		-e "s:\$(CXX):\$(CXX) \$(CXXFLAGS) -I\"${S}\"/argh:g" \
		Makefile || die

	sed -i \
		 -e "s:CPPFLAGS=:CPPFLAGS=-I\"${S}\"/argh :" \
		Makefile.sets || die

	echo "" > .depend || die
	echo "" > argh/.depend || die
	default
}

src_compile() {
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" \
		CXXFLAGS="${CXXFLAGS}" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" -j1
}

src_install() {
	dobin erec
	einstalldocs
}
