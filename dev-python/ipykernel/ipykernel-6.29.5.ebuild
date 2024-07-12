# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 python3_{10..13} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 pypi virtualx

DESCRIPTION="IPython Kernel for Jupyter"
HOMEPAGE="
	https://github.com/ipython/ipykernel/
	https://pypi.org/project/ipykernel/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos"

RDEPEND="
	>=dev-python/comm-0.1.1[${PYTHON_USEDEP}]
	>=dev-python/ipython-7.23.1[${PYTHON_USEDEP}]
	>=dev-python/jupyter-client-8[${PYTHON_USEDEP}]
	>=dev-python/jupyter-core-4.12[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-inline-0.1[${PYTHON_USEDEP}]
	dev-python/nest-asyncio[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-24[${PYTHON_USEDEP}]
	>=dev-python/tornado-6.1[${PYTHON_USEDEP}]
	>=dev-python/traitlets-5.4.0[${PYTHON_USEDEP}]
"
# RDEPEND seems specifically needed in BDEPEND, at least jupyter
# bug #816486
# pytest-8 runs a small subset of tests, we allow newer for 3.13
# since a few tests are better than skipping entirely
BDEPEND="
	${RDEPEND}
	test? (
		dev-python/flaky[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			<dev-python/pytest-8[${PYTHON_USEDEP}]
		' 3.{10..12})
		>=dev-python/pytest-asyncio-0.23.5[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		dev-python/ipyparallel[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

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
	local EPYTEST_DESELECT=(
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

	virtx distutils-r1_src_test
}
