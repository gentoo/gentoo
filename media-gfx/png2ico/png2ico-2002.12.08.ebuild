# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="PNG to icon converter"
HOMEPAGE="http://winterdrache.de/freeware/png2ico/index.html"
SRC_URI="http://winterdrache.de/freeware/${PN}/data/${PN}-src-${PV/./-}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/libpng:0=
	sys-libs/zlib:="
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-memset_and_strcmp.patch

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
