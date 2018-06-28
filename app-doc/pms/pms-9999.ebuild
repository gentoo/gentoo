# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/${PN}.git"
DESCRIPTION="Gentoo Package Manager Specification (draft)"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Package_Manager_Specification"

LICENSE="CC-BY-SA-3.0"
SLOT="live"
IUSE="html twoside"

# texlive-bibtexextra: plainurl.bst
# texlive-latexextra: chngcntr, isodate, marginnote, paralist, tocbibind
# texlive-mathscience: algorithm, algorithmic
# leaflet used by eapi-cheatsheet
BDEPEND="dev-tex/leaflet
	dev-texlive/texlive-bibtexextra
	dev-texlive/texlive-fontsrecommended
	dev-texlive/texlive-latex
	dev-texlive/texlive-latexextra
	dev-texlive/texlive-latexrecommended
	dev-texlive/texlive-mathscience
	html? (
		app-text/recode
		>=dev-tex/tex4ht-20090611_p1038-r5
	)"

src_compile() {
	# just in case; we shouldn't be generating any fonts
	export VARTEXFONTS="${T}/fonts"
	emake $(usex twoside TWOSIDE=yes "")
	use html && emake html
}

src_install() {
	dodoc pms.pdf eapi-cheatsheet.pdf
	if use html; then
		docinto html
		dodoc *.html pms.css
		dosym {..,/usr/share/doc/${PF}/html}/eapi-cheatsheet.pdf
	fi
}
