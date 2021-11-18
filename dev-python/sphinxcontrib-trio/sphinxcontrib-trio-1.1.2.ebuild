# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Make Sphinx better at documenting Python functions and methods"
HOMEPAGE="
	https://github.com/python-trio/sphinxcontrib-trio
	https://pypi.org/project/sphinxcontrib-trio
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="|| ( Apache-2.0 MIT )"
KEYWORDS="amd64 ~arm arm64 hppa ~ia64 ~ppc ppc64 ~riscv sparc x86"
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
	epytest --deselect tests/test_sphinxcontrib_trio.py::test_end_to_end
}
