# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Chemical structure drawing program - focused on presentation"
HOMEPAGE="http://easychem.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/easychem/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"

RDEPEND="
	app-text/ghostscript-gpl
	media-gfx/pstoedit
	x11-libs/gtk+:2
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/perl
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PV}-gentoo.patch
	"${FILESDIR}"/${PN}-0.6-clang16-fix.patch
)

src_prepare() {
	default
	tc-export CC
}

src_compile() {
	ln -s Makefile.linux Makefile || die
	DGS_PATH="${EPREFIX}"/usr/bin DPSTOEDIT_PATH="${EPREFIX}"/usr/bin \
		C_FLAGS="${CFLAGS}" emake -e
}

src_install() {
	dobin easychem
	dodoc TODO
}
