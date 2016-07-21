# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION=" The PHYLogeny Inference Package"
HOMEPAGE="http://evolution.genetics.washington.edu/phylip.html"
SRC_URI="http://evolution.gs.washington.edu/${PN}/download/${P}.tar.gz"

SLOT="0"
LICENSE="freedist"
IUSE=""
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="x11-libs/libXaw"
DEPEND="${RDEPEND}
	x11-proto/xproto"

S="${WORKDIR}/${P}/src"

src_prepare() {
	sed \
		-e "s/CFLAGS  = -O3 -fomit-frame-pointer/CFLAGS = ${CFLAGS}/" \
		-e "s/CC        = cc/CC        = $(tc-getCC)/" \
		-e "s/DC        = cc/DC        = $(tc-getCC)/" \
		-e "/ -o /s:\(\$(CC)\):\1 ${LDFLAGS}:g" \
		-i Makefile || die "Patching Makefile failed."
	mkdir ../fonts || die
}

src_compile() {
	emake -j1 all put
}

src_install() {
	cd "${WORKDIR}/${P}" || die

	mv exe/font* fonts || die "Font move failed."
	mv exe/factor exe/factor-${PN} || die "Renaming factor failed."

	dobin exe/*

	dodoc "${FILESDIR}"/README.Gentoo

	dohtml -r phylip.html doc

	insinto /usr/share/${PN}/
	doins -r fonts
}
