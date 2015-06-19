# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/m2vrequantizer/m2vrequantizer-0.0.2_pre20060306.ebuild,v 1.1 2011/01/22 23:55:50 hd_brummy Exp $

EAPI="2"

MY_P="${PN/m2vr/M2VR}-20060306"

DESCRIPTION="Tool to requantize mpeg2 videos"
HOMEPAGE="http://www.metakine.com/products/dvdremaster/modules.html"
SRC_URI="mirror://vdrfiles/requant/${MY_P}.tgz"

KEYWORDS="~amd64 x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}/M2VRequantiser

src_prepare() {

	sed -i "s:#elif defined(__i386__):#elif defined(__i386__) || defined(__amd64__):" main.c
}

src_compile() {

	gcc -c ${CFLAGS} main.c -o requant.o
	gcc ${CFLAGS} ${LDFLAGS} requant.o -o requant -lm
}

src_install() {

	dobin requant
}
