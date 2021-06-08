# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} pypy3 )
inherit distutils-r1

DESCRIPTION="Pretty-print tabular data"
HOMEPAGE="https://pypi.org/project/tabulate/ https://github.com/astanin/python-tabulate"
SRC_URI="https://github.com/astanin/python-${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/python-${P}"

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/wcwidth[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		$(python_gen_impl_dep 'sqlite')
		dev-python/colorclass[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/numpy[${PYTHON_USEDEP}]' 'python3*')
	)
"

distutils_enable_tests pytest

python_test() {
	local deselect=(
		# avoid pandas dependency
		test/test_input.py::test_pandas
		test/test_input.py::test_pandas_firstrow
		test/test_input.py::test_pandas_keys
		test/test_output.py::test_pandas_with_index
		test/test_output.py::test_pandas_without_index
		test/test_output.py::test_pandas_rst_with_index
		test/test_output.py::test_pandas_rst_with_named_index
	)
	epytest ${deselect[@]/#/--deselect }
}
