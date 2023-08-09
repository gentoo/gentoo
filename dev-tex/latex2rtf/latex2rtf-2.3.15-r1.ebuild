# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="LaTeX to RTF converter"
HOMEPAGE="https://latex2rtf.sourceforge.net/"
SRC_URI="mirror://sourceforge/latex2rtf/${P}.tar.gz"
S="${WORKDIR}/${P%b}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/latex-base
	media-gfx/imagemagick"
BDEPEND="${RDEPEND}
	virtual/texi2dvi
	test? (
		dev-texlive/texlive-langgerman
		dev-texlive/texlive-fontsrecommended
		dev-texlive/texlive-latexextra
		dev-tex/latex2html
	)"

src_compile() {
	export VARTEXFONTS="${T}"/fonts

	tc-export CC
	# Set DESTDIR here too so that compiled-in paths are correct.
	emake DESTDIR="${EPREFIX}"/usr

	# Needed for tests
	chmod +x test/bracecheck || die

	emake -C doc realclean
	emake -C doc -j1
}

src_install() {
	dodoc README* HACKING ToDo ChangeLog doc/credits
	emake DESTDIR="${ED}"/usr -j1 install install-info
}
