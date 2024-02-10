# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="ID3 tag editor for mp3 files"
HOMEPAGE="http://code.fluffytapeworm.com/projects/id3ed"
SRC_URI="http://code.fluffytapeworm.com/projects/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"

DEPEND="sys-libs/ncurses:0=
	sys-libs/readline:0="
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -i \
		-e '/install/s:-s::' \
		-e 's:$(CXX) $(CXXFLAGS):$(CXX) $(LDFLAGS) $(CXXFLAGS):' \
		Makefile.in || die
}

src_compile() {
	emake CXX="$(tc-getCXX)" CFLAGS="${CFLAGS} -I./"
}

src_install() {
	dodir /usr/bin /usr/share/man/man1
	default
}
