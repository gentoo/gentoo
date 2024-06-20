# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit latex-package

DESCRIPTION="LaTeX class for creating presentations using a video projector"
HOMEPAGE="https://github.com/josephwright/beamer"
SRC_URI="https://github.com/josephwright/beamer/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/beamer-${PV}"

LICENSE="GPL-2 FDL-1.2 LPPL-1.3c"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="doc"

BDEPEND="dev-texlive/texlive-latex"
RDEPEND="
	>=dev-tex/pgf-1.10
	dev-texlive/texlive-latexrecommended
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
