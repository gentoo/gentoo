# Copyright 1999-2025 Gentoo Authors
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
	https://github.com/gpoore/${PN}/archive/refs/tags/python/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

S="${WORKDIR}/${PN}-python-v${PV}"

LICENSE="LPPL-1.3c"
SLOT="0"
KEYWORDS="amd64"

# fontsextra for fourier.sty
# latexextra for upquote.sty
BDEPEND="
	>=dev-texlive/texlive-fontsextra-2024
	>=dev-texlive/texlive-latexextra-2024
"

distutils_enable_tests pytest

src_compile() {
	pushd python > /dev/null || die
	distutils-r1_src_compile
	popd > /dev/null || die

	pushd latex/latex2pydata > /dev/null || die
	latex-package_src_compile
	popd > /dev/null || die
}

src_test() {
	pushd python > /dev/null || die
	distutils-r1_src_test
	popd > /dev/null || die
}

src_install() {
	dodoc README.md

	pushd python > /dev/null || die
	distutils-r1_src_install
	docinto python
	dodoc CHANGELOG.md README.md
	popd > /dev/null || die

	pushd latex  > /dev/null || die
	docinto latex
	dodoc CHANGELOG.md README.md
	popd > /dev/null || die

	pushd latex/latex2pydata > /dev/null || die
	latex-package_src_install
	popd > /dev/null || die
}
