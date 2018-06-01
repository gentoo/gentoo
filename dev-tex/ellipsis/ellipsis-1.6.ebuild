# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit latex-package

DESCRIPTION="Simple package that fixes the way LaTeX centers ellipses"
HOMEPAGE="http://www.ctan.org/tex-archive/macros/latex/contrib/ellipsis/"
# Downloaded from:
# ftp://tug.ctan.org/tex-archive/macros/latex/contrib/ellipsis.zip
SRC_URI="mirror://gentoo/${P}.zip"
IUSE=""
KEYWORDS="~amd64 ~x86"
LICENSE="LPPL-1.2"
SLOT="0"

DEPEND="app-arch/unzip"

S="${WORKDIR}/${PN}"

src_install() {
	export VARTEXFONTS="${T}/fonts"

	latex-package_src_install

	dodoc README ellipsis.pdf \
		|| die "Installing the documentation failed."
}
