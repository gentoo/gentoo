# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit toolchain-funcs

DESCRIPTION="LaTeX to RTF converter"
HOMEPAGE="http://latex2rtf.sourceforge.net/"
SRC_URI="mirror://sourceforge/latex2rtf/${P}a.tar.gz" # 'a' is only for 2.3.11 version for fixing a tarball generation bug

LICENSE="GPL-2"
KEYWORDS="alpha ~amd64 hppa ~ia64 ~ppc ppc64 ~sparc ~x86"
SLOT="0"
IUSE="test"
S="${WORKDIR}/${P%b}"

RDEPEND="
	virtual/latex-base
	media-gfx/imagemagick
"
DEPEND="${RDEPEND}
	virtual/texi2dvi
	test? (
		dev-texlive/texlive-langgerman
		dev-texlive/texlive-fontsrecommended
		dev-texlive/texlive-latexextra
		dev-tex/latex2html
	)
"

src_compile() {
	export VARTEXFONTS="${T}/fonts"
	tc-export CC
	# Set DESTDIR here too so that compiled-in paths are correct.
	emake DESTDIR="${EPREFIX}/usr" || die "emake failed"

	cd "${S}/doc"
	emake realclean
	emake -j1
}

src_install() {
	dodoc README* HACKING ToDo ChangeLog doc/credits
	emake DESTDIR="${ED}/usr" -j1 install install-info
}
