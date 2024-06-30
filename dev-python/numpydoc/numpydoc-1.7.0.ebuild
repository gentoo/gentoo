# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Sphinx extension to support docstrings in Numpy format"
HOMEPAGE="
	https://numpydoc.readthedocs.io/en/latest/
	https://github.com/numpy/numpydoc/
	https://pypi.org/project/numpydoc/
"
SRC_URI="
	https://github.com/numpy/numpydoc/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

RDEPEND="
	>=dev-python/sphinx-6[${PYTHON_USEDEP}]
	>=dev-python/tabulate-0.8.10[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/tomli-1.1.0[${PYTHON_USEDEP}]
	' 3.10)
"
BDEPEND="
	test? (
		>=dev-python/matplotlib-3.2.1[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# these require Internet (intersphinx)
		numpydoc/tests/test_full.py::test_MyClass
		numpydoc/tests/test_full.py::test_my_function
		# TODO
		numpydoc/tests/test_validate.py::test_extract_ignore_validation_comments
	)
	epytest -o addopts= --pyargs numpydoc
}
