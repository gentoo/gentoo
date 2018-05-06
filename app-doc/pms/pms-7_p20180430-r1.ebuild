# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Gentoo Package Manager Specification"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Package_Manager_Specification"
SRC_URI="!binary? ( https://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz )
	binary? ( https://dev.gentoo.org/~ulm/distfiles/${P}-prebuilt.tar.xz )"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="binary html twoside"

# texlive-bibtexextra: plainurl.bst
# texlive-latexextra: chngcntr, isodate, marginnote, paralist, tocbibind
# texlive-mathscience: algorithm, algorithmic
# leaflet used by eapi-cheatsheet
BDEPEND="!binary? (
		dev-tex/leaflet
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsrecommended
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-latexrecommended
		dev-texlive/texlive-mathscience
		html? (
			app-text/recode
			>=dev-tex/tex4ht-20090611_p1038-r5
		)
	)"

src_compile() {
	if ! use binary; then
		# just in case; we shouldn't be generating any fonts
		export VARTEXFONTS="${T}/fonts"
		emake $(usex twoside TWOSIDE=yes "")
		use html && emake html
	else
		use twoside && ewarn "USE=twoside is not supported with USE=binary"
	fi
}

src_install() {
	dodoc pms.pdf eapi-cheatsheet.pdf
	if use html; then
		docinto html
		dodoc *.html pms.css
		dosym {..,/usr/share/doc/${PF}/html}/eapi-cheatsheet.pdf
	fi
}
