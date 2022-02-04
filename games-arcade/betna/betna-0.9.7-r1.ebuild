# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DESCRIPTION="Defend your volcano from the attacking ants by firing rocks/bullets at them"
HOMEPAGE="http://koti.mbnet.fi/makegho/c/betna/"
SRC_URI="http://koti.mbnet.fi/makegho/c/betna/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-libs/libsdl[video]"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	sed -i \
		-e '/blobprintf.*char msg/s/char msg/const char msg/' \
		-e "s:images/:/var/lib/${PN}/:" \
		src/main.cpp || die

	sed -i \
		-e '/^LDFLAGS/d' \
		-e '/--libs/s/-o/$(LDFLAGS) -o/' \
		-e 's:-O2:$(CXXFLAGS):g' \
		-e 's/g++/$(CXX)/' \
		Makefile || die
}

src_configure() {
	tc-export CXX
}

src_compile() {
	emake clean
	emake
}

src_install() {
	dobin betna
	dodoc README Q\&A

	insinto /var/lib/${PN}
	doins images/*

	newicon images/target.bmp ${PN}.bmp

	make_desktop_entry ${PN} Betna /usr/share/pixmaps/${PN}.bmp
}
