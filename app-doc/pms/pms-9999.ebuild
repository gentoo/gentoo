# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

EGIT_REPO_URI="git://anongit.gentoo.org/proj/${PN}.git
	https://anongit.gentoo.org/git/proj/${PN}.git"

DESCRIPTION="Gentoo Package Manager Specification (draft)"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Package_Manager_Specification"

LICENSE="CC-BY-SA-3.0"
SLOT="live"
IUSE="html"

DEPEND="dev-tex/leaflet
	dev-texlive/texlive-bibtexextra
	dev-texlive/texlive-latex
	dev-texlive/texlive-latexextra
	dev-texlive/texlive-latexrecommended
	|| ( dev-texlive/texlive-mathscience dev-texlive/texlive-science )
	html? (
		app-text/recode
		>=dev-tex/tex4ht-20090611_p1038-r5
	)"
RDEPEND=""

src_compile() {
	emake
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
