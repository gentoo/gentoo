# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/${PN}.git"
EGIT_BRANCH="master"
DESCRIPTION="Gentoo Package Manager Specification (draft)"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Package_Manager_Specification"

LICENSE="CC-BY-SA-4.0"
SLOT="live"
IUSE="html twoside"

# texlive-bibtexextra for unsrturl.bst
# texlive-latexextra for chngcntr, gitinfo2, isodate, leaflet, marginnote,
#   paralist, tocbibind
# texlive-mathscience for algorithm, algorithmic
BDEPEND="dev-texlive/texlive-bibtexextra
	>=dev-texlive/texlive-latexextra-2020-r2
	dev-texlive/texlive-mathscience
	virtual/latex-base
	html? ( >=dev-tex/tex4ht-20090611_p1038-r11 )"
RDEPEND="!app-doc/pms-bin"

src_compile() {
	# just in case; we shouldn't be generating any fonts
	export VARTEXFONTS="${T}/fonts"
	emake $(usev twoside TWOSIDE=yes)
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
