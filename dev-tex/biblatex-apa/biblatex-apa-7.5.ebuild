# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package

DESCRIPTION="APA style for BibLaTeX"
HOMEPAGE="https://www.ctan.org/pkg/biblatex-apa https://github.com/plk/biblatex-apa"
SRC_URI="https://github.com/plk/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LPPL-1.3c"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-texlive/texlive-latexextra
	>=dev-tex/biblatex-3.8
	>=dev-tex/biber-2.8"
DEPEND="${RDEPEND}"

src_install() {
	insinto "${TEXMF}"
	doins -r tex
}
