# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package

DESCRIPTION="LaTeX class for creating presentations using a video projector"
HOMEPAGE="https://github.com/josephwright/beamer"
SRC_URI="https://github.com/josephwright/beamer/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/beamer-${PV}"

LICENSE="GPL-2 FDL-1.2 LPPL-1.3c"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc"

BDEPEND="dev-texlive/texlive-latex"
RDEPEND="
	>=dev-tex/pgf-1.10
	dev-texlive/texlive-latexrecommended
	!dev-tex/translator
"

src_prepare() {
	default
	rm -r doc/licenses || die
}

src_install() {
	insinto /usr/share/texmf-site/tex/latex/beamer
	doins -r base

	dodoc README.md

	if use doc ; then
		docinto doc
		dodoc -r  doc
		dosym ../../../../../usr/share/doc/${PF}/doc/ "${TEXMF}/doc/latex/beamer"
	fi
}
