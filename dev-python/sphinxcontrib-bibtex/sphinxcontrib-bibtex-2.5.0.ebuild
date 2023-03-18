# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Sphinx extensions for BibTeX style citations"
HOMEPAGE="https://github.com/mcmtroffaes/sphinxcontrib-bibtex"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/docutils-0.8[${PYTHON_USEDEP}]
	>=dev-python/importlib_metadata-3.6[${PYTHON_USEDEP}]
	>=dev-python/pybtex-0.24[${PYTHON_USEDEP}]
	>=dev-python/pybtex-docutils-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/sphinx-2.1[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/numpydoc[${PYTHON_USEDEP}]
	)
"

EPYTEST_DESELECT=(
	# rinoh not packaged
	test/test_citation_rinoh.py::test_citation_rinoh
	test/test_citation_rinoh.py::test_citation_rinoh_multidoc
)

distutils_enable_tests pytest
distutils_enable_sphinx doc

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}" -name '*.pth' -delete || die
}

python_test() {
	distutils_write_namespace sphinxcontrib
	epytest
}
