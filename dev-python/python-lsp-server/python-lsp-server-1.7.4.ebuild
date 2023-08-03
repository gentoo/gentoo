# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 optfeature pypi

DESCRIPTION="Python Language Server for the Language Server Protocol"
HOMEPAGE="https://github.com/python-lsp/python-lsp-server"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 x86"
IUSE="all-plugins"

BDEPEND="
	test? (
		>=dev-python/autopep8-1.6.0[${PYTHON_USEDEP}]
		dev-python/flaky[${PYTHON_USEDEP}]
		>=dev-python/flake8-5.0.0[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		>=dev-python/mccabe-0.7.0[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		>=dev-python/pycodestyle-2.9.0[${PYTHON_USEDEP}]
		>=dev-python/pydocstyle-6.3.0[${PYTHON_USEDEP}]
		<dev-python/pydocstyle-6.4.0[${PYTHON_USEDEP}]
		>=dev-python/pyflakes-2.5.0[${PYTHON_USEDEP}]
		>=dev-python/pylint-2.5.0[${PYTHON_USEDEP}]
		dev-python/QtPy[gui,testlib,${PYTHON_USEDEP}]
		>=dev-python/rope-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/yapf-0.33.0[${PYTHON_USEDEP}]
		>=dev-python/whatthepatch-1.0.2[${PYTHON_USEDEP}]
	)
"

RDEPEND="
	dev-python/docstring-to-markdown[${PYTHON_USEDEP}]
	>=dev-python/jedi-0.17.2[${PYTHON_USEDEP}]
	>=dev-python/python-lsp-jsonrpc-1.0.0[${PYTHON_USEDEP}]
	dev-python/pluggy[${PYTHON_USEDEP}]
	all-plugins? (
		>=dev-python/autopep8-1.6.0[${PYTHON_USEDEP}]
		>=dev-python/flake8-5.0.0[${PYTHON_USEDEP}]
		>=dev-python/mccabe-0.7.0[${PYTHON_USEDEP}]
		>=dev-python/pycodestyle-2.9.0[${PYTHON_USEDEP}]
		>=dev-python/pydocstyle-6.3.0[${PYTHON_USEDEP}]
		<dev-python/pydocstyle-6.4.0[${PYTHON_USEDEP}]
		>=dev-python/pyflakes-2.5.0[${PYTHON_USEDEP}]
		>=dev-python/pylint-2.5.0[${PYTHON_USEDEP}]
		>=dev-python/rope-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/yapf-0.33.0[${PYTHON_USEDEP}]
		>=dev-python/whatthepatch-1.0.2[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# broken by presence of pathlib2
	'test/plugins/test_autoimport.py'
)

python_prepare_all() {
	# remove pytest-cov dep
	sed -i -e '/addopts =/d' pyproject.toml || die
	# unpin all the deps
	sed -i -e 's:,<[0-9.]*::' pyproject.toml || die
	distutils-r1_python_prepare_all
}

pkg_postinst() {
	optfeature "Automatically format Python code to conform to the PEP 8 style guide" dev-python/autopep8
	optfeature "A wrapper around PyFlakes, pep8 & mccabe" dev-python/flake8
	optfeature "flake8 plugin: McCabe complexity checker" dev-python/mccabe
	optfeature "Python style guide checker (fka pep8)" dev-python/pycodestyle
	optfeature "Python docstring style checker" dev-python/pydocstyle
	optfeature "Passive checker for Python programs" dev-python/pyflakes
	optfeature "Python code static checker" dev-python/pylint
	optfeature "Python refactoring library" dev-python/rope
	optfeature "A formatter for Python files" dev-python/yapf
}
