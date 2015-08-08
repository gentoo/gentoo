# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit toolchain-funcs

DESCRIPTION="True Audio Compressor Software"
HOMEPAGE="http://tta.sourceforge.net"
SRC_URI="mirror://sourceforge/tta/${P}-src.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="sys-apps/sed"

S=${WORKDIR}/${P}-src

src_prepare() {
	sed -i -e "s:gcc:$(tc-getCC):g" \
		-e "s:-o:${LDFLAGS} -o:g" \
		Makefile || die
}

src_compile () {
	emake CFLAGS="${CFLAGS}"
}

src_install () {
	dobin ttaenc
	dodoc ChangeLog-${PV} README
}
