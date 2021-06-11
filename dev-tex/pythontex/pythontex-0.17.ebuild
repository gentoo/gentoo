# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit latex-package python-r1

DESCRIPTION="Fast Access to Python from within LaTeX"
HOMEPAGE="https://github.com/gpoore/pythontex"
SRC_URI="https://github.com/gpoore/pythontex/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="LPPL-1.3 BSD"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc highlighting"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	>=dev-texlive/texlive-latexextra-2016
	dev-tex/pgf"
RDEPEND="${DEPEND}
	dev-python/pygments[${PYTHON_USEDEP}]"

TEXMF=/usr/share/texmf-site

src_compile() {
	cd ${PN} || die
	rm ${PN}.sty || die
	VARTEXFONTS="${T}/fonts" latex ${PN}.ins extra || die
}

src_install() {
	dodoc *rst
	use doc && dodoc ${PN}_quickstart/*pdf ${PN}/*pdf

	cd ${PN} || die

	installation() {
		python_domodule {de,}${PN}3.py
		python_domodule ${PN}_{engines,utils}.py
		python_doscript {de,}${PN}.py syncpdb.py
		python_optimize
	}
	python_foreach_impl installation

	latex-package_src_doinstall sty
}
