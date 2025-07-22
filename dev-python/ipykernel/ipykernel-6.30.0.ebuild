# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3_11 python3_{11..13} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 pypi virtualx

DESCRIPTION="IPython Kernel for Jupyter"
HOMEPAGE="
	https://github.com/ipython/ipykernel/
	https://pypi.org/project/ipykernel/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos"

RDEPEND="
	>=dev-python/comm-0.1.1[${PYTHON_USEDEP}]
	>=dev-python/ipython-7.23.1[${PYTHON_USEDEP}]
	>=dev-python/jupyter-client-8.0.0[${PYTHON_USEDEP}]
	>=dev-python/jupyter-core-4.12[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-inline-0.1[${PYTHON_USEDEP}]
	>=dev-python/nest-asyncio-1.4[${PYTHON_USEDEP}]
	>=dev-python/packaging-22[${PYTHON_USEDEP}]
	>=dev-python/psutil-5.7[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-25[${PYTHON_USEDEP}]
	>=dev-python/tornado-6.2[${PYTHON_USEDEP}]
	>=dev-python/traitlets-5.4.0[${PYTHON_USEDEP}]
"
# RDEPEND seems specifically needed in BDEPEND, at least jupyter
# bug #816486
# pytest-8 runs a small subset of tests, we allow newer for 3.13
# since a few tests are better than skipping entirely
BDEPEND="
	${RDEPEND}
	test? (
		dev-python/ipyparallel[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( flaky pytest-{asyncio,timeout} )
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# TODO
	tests/test_debugger.py::test_attach_debug
	tests/test_debugger.py::test_breakpoint_in_cell_with_leading_empty_lines
	tests/test_debugger.py::test_rich_inspect_at_breakpoint
	tests/test_debugger.py::test_rich_inspect_not_at_breakpoint
	tests/test_debugger.py::test_set_breakpoints
	tests/test_debugger.py::test_stop_on_breakpoint
	tests/test_debugger.py::test_copy_to_globals
	# hangs?
	tests/test_eventloop.py::test_tk_loop
	# doesn't like pyside2?
	tests/test_eventloop.py::test_qt_enable_gui
)

src_prepare() {
	# debugpy is actually optional
	sed -i -e '/debugpy/d' pyproject.toml || die
	distutils-r1_src_prepare
}

python_compile() {
	distutils-r1_python_compile
	# Use python3 in kernel.json configuration, bug #784764
	sed -i -e '/python3.[0-9]\+/s//python3/' \
		"${BUILD_DIR}/install${EPREFIX}/usr/share/jupyter/kernels/python3/kernel.json" || die
}

src_test() {
	virtx distutils-r1_src_test
}
