# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 latex-package

DESCRIPTION="LaTeX package for source code syntax highlighting"
HOMEPAGE="https://github.com/gpoore/minted/"
SRC_URI="
	https://github.com/gpoore/${PN}/archive/refs/tags/latex/v${PV}.tar.gz
		-> ${P}.tar.gz
	https://github.com/gpoore/minted/commit/45ccea404689680513be3b78d2c0579f6250f963.patch
		-> ${PN}-3.4.0-explicitly-set-build-backend.patch
"

S="${WORKDIR}"/${PN}-latex-v${PV}

LICENSE="|| ( BSD LPPL-1.3 )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ppc ppc64 ~riscv x86"

IUSE="doc"

RDEPEND="
	>=dev-python/latexrestricted-0.6.0
	>=dev-python/pygments-2.17.0
	>=dev-tex/latex2pydata-0.4.0
	dev-texlive/texlive-latexextra
"
BDEPEND="
	doc? (
		dev-texlive/texlive-fontsextra
	)
"

PATCHES=(
	"${DISTDIR}"/${PN}-3.4.0-explicitly-set-build-backend.patch
)

src_prepare() {
	default

	rm latex/minted/${PN}.pdf || die
}

src_compile() {
	pushd python &> /dev/null || die
	distutils-r1_src_compile
	popd &> /dev/null || die

	pushd latex/minted &> /dev/null || die
	latex-package_src_compile
	popd &> /dev/null || die
}

src_install() {
	dodoc README.md

	pushd python &> /dev/null || die
	docinto python
	dodoc *.md
	distutils-r1_src_install
	popd &> /dev/null || die

	pushd latex &> /dev/null || die
	docinto latex
	dodoc *.md
	popd &> /dev/null || die

	pushd latex/minted &> /dev/null || die
	latex-package_src_doinstall styles fonts bin
	if use doc; then
		python_setup
		local -x LATEX_DOC_ARGUMENTS="-shell-escape"
		local -x PYTHONPATH="${ED}/usr/lib/${EPYTHON}/site-packages"
		local -x PATH="${ED}/usr/lib/python-exec/${EPYTHON}:${PATH}"
		latex-package_src_doinstall doc
	fi
	popd &> /dev/null || die
}
