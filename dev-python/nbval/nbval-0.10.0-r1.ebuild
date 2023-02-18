# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="A pytest plugin to validate Jupyter notebooks"
HOMEPAGE="https://github.com/computationalmodelling/nbval"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/coverage[${PYTHON_USEDEP}]
	dev-python/ipykernel[${PYTHON_USEDEP}]
	dev-python/jupyter_client[${PYTHON_USEDEP}]
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
