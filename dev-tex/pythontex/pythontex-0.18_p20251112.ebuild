# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..13} )

inherit latex-package python-r1

COMMIT="63484d82131f8f621dccde9c9649c98ff4e322f9"

DESCRIPTION="Fast Access to Python from within LaTeX"
HOMEPAGE="https://github.com/gpoore/pythontex"
SRC_URI="https://github.com/gpoore/pythontex/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="LPPL-1.3 BSD"
SLOT="0"
KEYWORDS="amd64 ppc ~riscv x86"
IUSE="doc highlighting"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	>=dev-texlive/texlive-latexextra-2023
	dev-tex/pgf
"
RDEPEND="${DEPEND}
	dev-python/pygments[${PYTHON_USEDEP}]
"

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
