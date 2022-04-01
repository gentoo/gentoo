# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="IPython Kernel for Jupyter"
HOMEPAGE="https://github.com/ipython/ipykernel"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	>=dev-python/debugpy-1.0[${PYTHON_USEDEP}]
	>=dev-python/ipython-7.23.1[${PYTHON_USEDEP}]
	>=dev-python/traitlets-5.1.0[${PYTHON_USEDEP}]
	>=dev-python/jupyter_client-6.1.12[${PYTHON_USEDEP}]
	>=www-servers/tornado-6.1[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-inline-0.1[${PYTHON_USEDEP}]
	dev-python/nest_asyncio[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	>=dev-python/setuptools-60[${PYTHON_USEDEP}]
"
# RDEPEND seems specifically needed in BDEPEND, at least jupyter
# bug #816486
BDEPEND="
	${RDEPEND}
	test? (
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		dev-python/ipyparallel[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# TODO
	ipykernel/tests/test_debugger.py::test_attach_debug
	ipykernel/tests/test_debugger.py::test_set_breakpoints
	ipykernel/tests/test_debugger.py::test_stop_on_breakpoint
	ipykernel/tests/test_debugger.py::test_breakpoint_in_cell_with_leading_empty_lines
	ipykernel/tests/test_debugger.py::test_rich_inspect_not_at_breakpoint
	ipykernel/tests/test_debugger.py::test_rich_inspect_at_breakpoint
)

src_prepare() {
	sed -i -e 's:^TIMEOUT = .*:TIMEOUT = 120:' ipykernel/tests/*.py || die
	distutils-r1_src_prepare
}

python_compile() {
	distutils-r1_python_compile
	# Use python3 in kernel.json configuration, bug #784764
	sed -i -e '/python3.[0-9]\+/s//python3/' \
		"${BUILD_DIR}/install${EPREFIX}/usr/share/jupyter/kernels/python3/kernel.json" || die
}
