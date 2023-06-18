# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..11} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 pypi virtualx

DESCRIPTION="IPython Kernel for Jupyter"
HOMEPAGE="
	https://github.com/ipython/ipykernel/
	https://pypi.org/project/ipykernel/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/comm-0.1.1[${PYTHON_USEDEP}]
	>=dev-python/debugpy-1.6.5[${PYTHON_USEDEP}]
	>=dev-python/ipython-7.23.1[${PYTHON_USEDEP}]
	>=dev-python/jupyter-client-8[${PYTHON_USEDEP}]
	>=dev-python/jupyter-core-4.12[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-inline-0.1[${PYTHON_USEDEP}]
	dev-python/nest_asyncio[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-20[${PYTHON_USEDEP}]
	>=dev-python/tornado-6.1[${PYTHON_USEDEP}]
	>=dev-python/traitlets-5.4.0[${PYTHON_USEDEP}]
"
# RDEPEND seems specifically needed in BDEPEND, at least jupyter
# bug #816486
BDEPEND="
	${RDEPEND}
	test? (
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		dev-python/ipyparallel[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

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

src_test() {
	local EPYTEST_DESELECT=(
		# TODO
		ipykernel/tests/test_debugger.py::test_attach_debug
		ipykernel/tests/test_debugger.py::test_breakpoint_in_cell_with_leading_empty_lines
		ipykernel/tests/test_debugger.py::test_rich_inspect_at_breakpoint
		ipykernel/tests/test_debugger.py::test_rich_inspect_not_at_breakpoint
		ipykernel/tests/test_debugger.py::test_set_breakpoints
		ipykernel/tests/test_debugger.py::test_stop_on_breakpoint
		ipykernel/tests/test_debugger.py::test_copy_to_globals
		# hangs?
		ipykernel/tests/test_eventloop.py::test_tk_loop
	)

	virtx distutils-r1_src_test
}
