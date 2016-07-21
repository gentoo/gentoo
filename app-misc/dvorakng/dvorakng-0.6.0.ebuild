# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit toolchain-funcs

DESCRIPTION="Dvorak typing tutor"
HOMEPAGE="http://freshmeat.net/projects/dvorakng/?topic_id=71%2C861"
SRC_URI="http://www.free.of.pl/n/nopik/${P}rc1.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
RDEPEND="
	sys-libs/ncurses:*
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

S=${WORKDIR}/${PN}

src_compile() {
	emake \
		CXX="$(tc-getCXX)" \
		CXXFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		LIBS="$( $(tc-getPKG_CONFIG) --libs ncurses )"
}

src_install() {
	dobin ${PN}
	dodoc README TODO
}
