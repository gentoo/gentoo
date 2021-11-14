# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="threads(+)"
inherit distutils-r1

DESCRIPTION="IPython Kernel for Jupyter"
HOMEPAGE="https://github.com/ipython/ipykernel"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ia64 ~ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="test"

RDEPEND="
	dev-python/ipython[${PYTHON_USEDEP}]
	<dev-python/jupyter_client-6.2[${PYTHON_USEDEP}]
	dev-python/jupyter_core[${PYTHON_USEDEP}]
	dev-python/traitlets[${PYTHON_USEDEP}]
	www-servers/tornado[${PYTHON_USEDEP}]"
# RDEPEND seems specifically needed in BDEPEND, at least jupyter
# bug #816486
BDEPEND="
	${RDEPEND}
	test? (
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/nose_warnings_filters[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e 's:^TIMEOUT = .*:TIMEOUT = 120:' ipykernel/tests/*.py || die
	distutils-r1_src_prepare
}

python_test() {
	local deselect=(
		# TODO
		ipykernel/tests/test_serialize.py::test_numpy_in_seq
		ipykernel/tests/test_serialize.py::test_numpy_in_dict
		ipykernel/tests/test_serialize.py::test_class
		ipykernel/tests/test_serialize.py::test_class_oldstyle
		ipykernel/tests/test_serialize.py::test_class_inheritance
		'ipykernel/tests/test_async.py::test_async_interrupt[trio]'
		'ipykernel/tests/test_async.py::test_async_interrupt[trio]'
	)

	epytest ${deselect[@]/#/--deselect }
}
