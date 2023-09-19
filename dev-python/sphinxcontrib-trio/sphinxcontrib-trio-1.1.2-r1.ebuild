# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Make Sphinx better at documenting Python functions and methods"
HOMEPAGE="
	https://github.com/python-trio/sphinxcontrib-trio
	https://pypi.org/project/sphinxcontrib-trio/
"

LICENSE="|| ( Apache-2.0 MIT )"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86"
SLOT="0"

RDEPEND="dev-python/sphinx[${PYTHON_USEDEP}]"

BDEPEND="
	test? (
		dev-python/async_generator[${PYTHON_USEDEP}]
		dev-python/cssselect[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
)"

# AttributeError: 'Sphinx' object has no attribute 'add_stylesheet'
#distutils_enable_sphinx docs/source
distutils_enable_tests pytest

python_test() {
	# https://github.com/python-trio/sphinxcontrib-trio/issues/260
	local -x PYTHONPATH="${BUILD_DIR}/install/usr/lib/${EPYTHON}/site-packages"
	epytest --deselect tests/test_sphinxcontrib_trio.py::test_end_to_end
}
