# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${PN}-${PV%%_*}"
DESCRIPTION="Gentoo Package Manager Specification"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Package_Manager_Specification"
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${MY_P}.tar.xz"

LICENSE="CC-BY-SA-3.0"
SLOT="${PV#*_p}"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="html"

BDEPEND="dev-tex/leaflet
	dev-texlive/texlive-bibtexextra
	dev-texlive/texlive-fontsrecommended
	dev-texlive/texlive-latex
	dev-texlive/texlive-latexextra
	dev-texlive/texlive-latexrecommended
	dev-texlive/texlive-mathscience
	html? (
		app-text/recode
		>=dev-tex/tex4ht-20090115_p0029
	)"
RDEPEND="!app-doc/pms-bin"

S="${WORKDIR}/${MY_P}"

src_compile() {
	# just in case; we shouldn't be generating any fonts
	export VARTEXFONTS="${T}/fonts"
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
