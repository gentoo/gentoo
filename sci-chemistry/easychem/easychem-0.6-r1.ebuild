# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Chemical structure drawing program - focused on presentation"
HOMEPAGE="http://easychem.sourceforge.net/"
SRC_URI="mirror://sourceforge/easychem/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	x11-libs/gtk+:2
	app-text/ghostscript-gpl
	media-gfx/pstoedit"
DEPEND="${RDEPEND}
	dev-lang/perl
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-gentoo.patch
	tc-export CC
}

src_compile() {
	ln -s Makefile.linux Makefile || die
	DGS_PATH="${EPREFIX}"/usr/bin DPSTOEDIT_PATH="${EPREFIX}"/usr/bin \
		C_FLAGS="${CFLAGS}" emake -e
}

src_install () {
	dobin easychem
	dodoc TODO
}
