# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P="${PN/m2vr/M2VR}-20060306"

DESCRIPTION="Tool to requantize mpeg2 videos"
HOMEPAGE="http://www.metakine.com/products/dvdremaster/modules.html"
SRC_URI="http://vdr.websitec.de/download/${PN}/M2VRequantizer-20060306.tgz"

KEYWORDS="~amd64 x86"
SLOT="0"
LICENSE="GPL-2"

S="${WORKDIR}/M2VRequantiser"

src_prepare() {
	default
	sed -i "s:#elif defined(__i386__):#elif defined(__i386__) || defined(__amd64__):" main.c || die
}

src_compile() {
	$(tc-getCC) -c ${CFLAGS} main.c -o requant.o || die
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} requant.o -o requant -lm || die
}

src_install() {
	dobin requant
}
