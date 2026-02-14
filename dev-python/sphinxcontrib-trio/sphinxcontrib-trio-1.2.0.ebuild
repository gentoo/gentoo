# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Make Sphinx better at documenting Python functions and methods"
HOMEPAGE="
	https://github.com/python-trio/sphinxcontrib-trio
	https://pypi.org/project/sphinxcontrib-trio/
"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	dev-python/sphinx[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/cssselect[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
	)
"

# AttributeError: 'Sphinx' object has no attribute 'add_stylesheet'
#distutils_enable_sphinx docs/source

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# https://github.com/python-trio/sphinxcontrib-trio/issues/260
		tests/test_sphinxcontrib_trio.py::test_end_to_end
	)

	local -x PYTHONPATH="${BUILD_DIR}/install$(python_get_sitedir)"
	epytest
}
