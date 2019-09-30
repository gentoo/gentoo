# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package

DESCRIPTION="LaTeX class for creating presentations using a video projector"
HOMEPAGE="https://github.com/josephwright/beamer"
SRC_URI="https://github.com/josephwright/beamer/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 FDL-1.2 LPPL-1.3c"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ia64 ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc"

DEPEND="dev-texlive/texlive-latex"
RDEPEND=">=dev-tex/pgf-1.10
	dev-tex/xcolor
	!dev-tex/translator"

S=${WORKDIR}/beamer-${PV}

src_prepare(){
	default
	rm -rf doc/licenses || die
}

src_install() {
	insinto /usr/share/texmf-site/tex/latex/beamer
	doins -r base

	dodoc README.md

	if use doc ; then
		docinto doc
		dodoc -r doc
		dosym "/usr/share/doc/${PF}/doc/" "${TEXMF}/doc/latex/beamer"
	fi
}
