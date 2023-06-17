# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi virtualx

DESCRIPTION="Jupyter notebook integration with Spyder"
HOMEPAGE="https://github.com/spyder-ide/spyder-notebook"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/jupyter-core[${PYTHON_USEDEP}]
	dev-python/nbformat[${PYTHON_USEDEP}]
	>=dev-python/notebook-4.3[${PYTHON_USEDEP}]
	dev-python/qdarkstyle[${PYTHON_USEDEP}]
	dev-python/QtPy[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	>=dev-python/spyder-5.4.3[${PYTHON_USEDEP}]
	<dev-python/spyder-6[${PYTHON_USEDEP}]
	dev-python/traitlets[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pytest-qt[${PYTHON_USEDEP}]
	)
"

DOCS=( "README.md" "CHANGELOG.md" )

distutils_enable_tests pytest

python_test() {
	virtx epytest
}
