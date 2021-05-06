# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="IPython Kernel for Jupyter"
HOMEPAGE="https://github.com/ipython/ipykernel"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"

RDEPEND="
	dev-python/ipython[${PYTHON_USEDEP}]
	dev-python/jupyter_client[${PYTHON_USEDEP}]
	dev-python/jupyter_core[${PYTHON_USEDEP}]
	dev-python/traitlets[${PYTHON_USEDEP}]
	www-servers/tornado[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/nose_warnings_filters[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

python_test() {
	local deselect=(
		# TODO
		ipykernel/tests/test_serialize.py::test_numpy_in_seq
		ipykernel/tests/test_serialize.py::test_numpy_in_dict
		ipykernel/tests/test_serialize.py::test_class
		ipykernel/tests/test_serialize.py::test_class_oldstyle
		ipykernel/tests/test_serialize.py::test_class_inheritance
	)

	epytest ${deselect[@]/#/--deselect }
}
