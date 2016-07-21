# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit toolchain-funcs

DESCRIPTION="ID3 tag editor for mp3 files"
HOMEPAGE="http://www.dakotacom.net/~donut/programs/id3ed.html"
SRC_URI="http://www.dakotacom.net/~donut/programs/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE=""

DEPEND="sys-libs/ncurses
	sys-libs/readline"

src_prepare() {
	sed -i \
		-e '/install/s:-s::' \
		-e 's:$(CXX) $(CXXFLAGS):$(CXX) $(LDFLAGS) $(CXXFLAGS):' \
		Makefile.in || die
}

src_compile() {
	emake CXX="$(tc-getCXX)" CFLAGS="${CFLAGS} -I./" || die
}

src_install() {
	dodir /usr/bin /usr/share/man/man1
	emake DESTDIR="${D}" install || die
	dodoc README || die
}
