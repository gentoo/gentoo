# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit toolchain-funcs

DESCRIPTION="LaTeX to RTF converter"
HOMEPAGE="http://latex2rtf.sourceforge.net/"
SRC_URI="mirror://sourceforge/latex2rtf/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
SLOT="0"
IUSE="doc test"
S="${WORKDIR}/${P%b}"

RDEPEND="virtual/latex-base
	media-gfx/imagemagick"
DEPEND="${RDEPEND}
	doc? ( virtual/texi2dvi )
	test? (
		dev-texlive/texlive-langgerman
		dev-texlive/texlive-fontsrecommended
		dev-texlive/texlive-latexextra
		dev-tex/latex2html
	)"

src_compile() {
	export VARTEXFONTS="${T}/fonts"
	# Set DESTDIR here too so that compiled-in paths are correct.
	emake DESTDIR="${EPREFIX}/usr" CC="$(tc-getCC)" || die "emake failed"
	if use doc; then
		cd "${S}/doc"
		emake realclean
		emake -j1
	fi
}

src_install() {
	dodoc README* HACKING ToDo ChangeLog doc/credits
	emake DESTDIR="${ED}/usr" -j1 install
	# if doc is not used, only the text version is intalled.
	if use doc; then
		emake DESTDIR="${ED}/usr" install-info
	fi
}
