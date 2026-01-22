# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1

MY_P=${P/_}
DESCRIPTION="Sphinx extension to support docstrings in Numpy format"
HOMEPAGE="
	https://numpydoc.readthedocs.io/en/latest/
	https://github.com/numpy/numpydoc/
	https://pypi.org/project/numpydoc/
"
SRC_URI="
	https://github.com/numpy/numpydoc/archive/v${PV/_}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

RDEPEND="
	>=dev-python/sphinx-6[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/matplotlib-3.2.1[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
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
