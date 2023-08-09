# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="A pytest plugin to validate Jupyter notebooks"
HOMEPAGE="https://github.com/computationalmodelling/nbval"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/coverage[${PYTHON_USEDEP}]
	dev-python/ipykernel[${PYTHON_USEDEP}]
	dev-python/jupyter-client[${PYTHON_USEDEP}]
	dev-python/nbformat[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/nbdime[${PYTHON_USEDEP}]
		dev-python/sympy[${PYTHON_USEDEP}]
	)
	doc? (
		virtual/pandoc
	)
"

EPYTEST_IGNORE=(
	# Mocker not packaged
	tests/test_nbdime_reporter.py

	tests/test_coverage.py
)

distutils_enable_tests pytest
distutils_enable_sphinx docs/source \
	dev-python/sphinx-rtd-theme \
	dev-python/numpy \
	dev-python/nbsphinx \
	dev-python/matplotlib

python_test() {
	PYTHONPATH=. epytest # 895258
}
