# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Gentoo Package Manager Specification"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Package_Manager_Specification"
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="html twoside"

# texlive-bibtexextra for plainurl.bst
# texlive-latexextra for chngcntr, isodate, leaflet, marginnote,
#   paralist, tocbibind
# texlive-mathscience for algorithm, algorithmic
BDEPEND="dev-texlive/texlive-bibtexextra
	>=dev-texlive/texlive-latexextra-2020-r2
	dev-texlive/texlive-mathscience
	virtual/latex-base
	html? (
		app-text/recode
		>=dev-tex/tex4ht-20090611_p1038-r11
	)"
RDEPEND="!app-doc/pms-bin"

PATCHES=(
	"${FILESDIR}/${PN}-7-Makefile.patch"
	"${FILESDIR}/${PN}-7-parskip.patch"
)

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
