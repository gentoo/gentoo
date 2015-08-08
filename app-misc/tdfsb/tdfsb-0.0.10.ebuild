# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="SDL based graphical file browser"
HOMEPAGE="http://www.determinate.net/webdata/seg/tdfsb.html"
SRC_URI="http://www.determinate.net/webdata/data/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ppc -sparc x86"
IUSE=""

DEPEND="media-libs/smpeg
	media-libs/sdl-image
	media-libs/freeglut"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-asneeded.patch \
		"${FILESDIR}"/${P}-debugging.patch

	sed -i -e "s:-O2:${CFLAGS} ${LDFLAGS}:" \
		-e "s:gcc:$(tc-getCC):" "${S}"/compile.sh || die
}

src_compile() {
	./compile.sh || die "compile failed"
}

src_install() {
	dobin tdfsb
	dodoc ChangeLog README
}
