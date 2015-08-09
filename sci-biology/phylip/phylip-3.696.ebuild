# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION=" The PHYLogeny Inference Package"
HOMEPAGE="http://evolution.genetics.washington.edu/phylip.html"
SRC_URI="http://evolution.gs.washington.edu/${PN}/download/${P}.tar.gz"

SLOT="0"
LICENSE="BSD-2"
IUSE=""
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="x11-libs/libXaw"
DEPEND="${RDEPEND}
	x11-proto/xproto"

S="${WORKDIR}/${P}/src"

src_prepare() {
	mv Makefile.unx Makefile || die
	sed \
		-e "/ -o /s:\(\$(CC)\):\1 ${LDFLAGS}:g" \
		-i Makefile || die "Patching Makefile failed."
	mkdir ../fonts || die
}

src_compile() {
	emake -j1 \
		CC="$(tc-getCC)" \
		DC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} -Wno-unused-result" \
		all put
}

src_install() {
	cd "${WORKDIR}/${P}" || die

	mv exe/font* fonts || die "Font move failed."
	mv exe/factor exe/factor-${PN} || die "Renaming factor failed."

	dobin exe/*

	dodoc "${FILESDIR}"/README.Gentoo

	dohtml -r phylip.html doc

	insinto /usr/share/${PN}/
	doins -r fonts
}
