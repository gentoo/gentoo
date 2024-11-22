# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 latex-package

DESCRIPTION="Allows LaTeX to save data to files using Python"
HOMEPAGE="
	https://github.com/gpoore/latex2pydata
	https://pypi.org/project/latex2pydata/
"
SRC_URI="
	https://github.com/gpoore/${PN}/archive/refs/tags/latex/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	https://github.com/gpoore/latex2pydata/commit/539ea2c24769a509728ac6ba52a20df588576376.patch
		-> ${PN}-0.4.0-explicitly-set-build-backend.patch
"

S="${WORKDIR}/${PN}-latex-v${PV}"

LICENSE="LPPL-1.3c"
SLOT="0"
KEYWORDS="~amd64"

PATCHES=(
	"${DISTDIR}"/${PN}-0.4.0-explicitly-set-build-backend.patch
)

# DEPEND=">=dev-texlive/texlive-latexextra-2024"

src_compile() {
	pushd python &> /dev/null || die
	distutils-r1_src_compile
	popd &> /dev/null || die

	pushd latex/latex2pydata &> /dev/null || die
	latex-package_src_compile
	popd &> /dev/null || die
}

src_install() {
	pushd python &> /dev/null || die
	distutils-r1_src_install
	docinto python
	dodoc *.md
	popd &> /dev/null || die

	pushd latex/latex2pydata &> /dev/null || die
	latex-package_src_install
	docinto latex
	dodoc *.md
	popd &> /dev/null || die
}
