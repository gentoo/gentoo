# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_P="${PN}-${PV%%_*}"
DESCRIPTION="Gentoo Package Manager Specification"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Package_Manager_Specification"
SRC_URI="!binary? ( https://dev.gentoo.org/~ulm/distfiles/${MY_P}.tar.xz )
	binary? ( https://dev.gentoo.org/~ulm/distfiles/${MY_P}-prebuilt.tar.xz )"

LICENSE="CC-BY-SA-3.0"
SLOT="${PV#*_p}"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="binary html"

DEPEND="!binary? (
		dev-tex/leaflet
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsrecommended
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-latexrecommended
		dev-texlive/texlive-mathscience
		html? (
			app-text/recode
			>=dev-tex/tex4ht-20090115_p0029
		)
	)"

S="${WORKDIR}/${MY_P}"

src_compile() {
	if ! use binary; then
		# just in case; we shouldn't be generating any fonts
		export VARTEXFONTS="${T}/fonts"
		emake
		use html && emake html
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
