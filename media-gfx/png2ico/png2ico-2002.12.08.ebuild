# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="PNG to icon converter"
HOMEPAGE="http://winterdrache.de/freeware/png2ico/index.html"
SRC_URI="http://winterdrache.de/freeware/${PN}/data/${PN}-src-${PV/./-}.tar.gz"
S="${WORKDIR}"/${PN}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libpng:0=
	sys-libs/zlib:=
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-memset_and_strcmp.patch
)

src_prepare() {
	default

	sed -i \
		-e 's:CPPFLAGS=-W -Wall -O2:CXXFLAGS+=-W -Wall:' \
		-e 's:g++ $(CPPFLAGS):$(CXX) $(LDFLAGS) $(CXXFLAGS):' \
		Makefile || die
}

src_compile() {
	tc-export CXX
	emake DEBUG=""
}

src_install() {
	dobin png2ico
	dodoc doc/bmp.txt README
	doman doc/png2ico.1
}
