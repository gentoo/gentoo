# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Code audit tool for python"
HOMEPAGE="https://github.com/klen/pylama"
SRC_URI="https://github.com/klen/pylama/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/mccabe-0.6.1[${PYTHON_USEDEP}]
	>=dev-python/pycodestyle-2.8.0[${PYTHON_USEDEP}]
	>=dev-python/pydocstyle-6.1.1[${PYTHON_USEDEP}]
	>=dev-python/pyflakes-2.4.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/eradicate[${PYTHON_USEDEP}]
		dev-python/mypy[${PYTHON_USEDEP}]
		dev-python/pylint[${PYTHON_USEDEP}]
		dev-python/radon[${PYTHON_USEDEP}]
		dev-vcs/git
	)
"

distutils_enable_sphinx docs
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# not packaged
	tests/test_linters.py::test_quotes
	tests/test_linters.py::test_vulture
)
