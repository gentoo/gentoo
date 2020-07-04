# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package

DESCRIPTION="Simple package that fixes the way LaTeX centers ellipses"
HOMEPAGE="https://www.ctan.org/tex-archive/macros/latex/contrib/ellipsis/"
# take from ftp://tug.ctan.org/tex-archive/macros/latex/contrib/ellipsis.zip
SRC_URI="mirror://gentoo/${P}.zip"

KEYWORDS="~amd64 ~x86"

LICENSE="LPPL-1.2"
SLOT="0"
IUSE=""

DEPEND="app-arch/unzip"

S="${WORKDIR}/${PN}"

src_install() {
	export VARTEXFONTS="${T}/fonts"

	latex-package_src_install
	dodoc README ellipsis.pdf
}
