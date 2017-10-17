# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit latex-package

DESCRIPTION="APA style for BibLaTeX"
HOMEPAGE="https://www.ctan.org/pkg/biblatex-apa https://github.com/plk/biblatex-apa"
SRC_URI="https://github.com/plk/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LPPL-1.3c"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-texlive/texlive-latexextra
	>=dev-tex/biblatex-3.4
	>=dev-tex/biber-2.5"
DEPEND="${RDEPEND}"

src_install() {
	insinto "${TEXMF}"
	doins -r tex
}
