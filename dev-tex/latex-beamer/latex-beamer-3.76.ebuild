# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo latex-package

DESCRIPTION="LaTeX class for creating presentations using a video projector"
HOMEPAGE="https://github.com/josephwright/beamer"
SRC_URI="https://github.com/josephwright/beamer/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/beamer-${PV}"

LICENSE="GPL-2 FDL-1.2 LPPL-1.3c"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="doc"

BDEPEND="
	dev-texlive/texlive-latex
	doc? (
		dev-texlive/texlive-langgerman
		dev-texlive/texlive-latexextra
	)
"
RDEPEND="
	>=dev-tex/pgf-1.10
	dev-texlive/texlive-latexrecommended
"

src_prepare() {
	default
	rm -r doc/licenses || die
}

src_compile() {
	if use doc; then
		edob -l l3build-doc l3build doc
	fi
}

src_install() {
	insinto /usr/share/texmf-site/tex/latex/beamer
	doins -r base

	dodoc README.md

	if use doc; then
		dodoc -r doc
		dosym ../../../../../usr/share/doc/${PF}/doc/ /usr/share/texmf-site/doc/latex/beamer
	fi
}
