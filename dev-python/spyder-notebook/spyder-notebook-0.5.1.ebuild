# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi virtualx

DESCRIPTION="Jupyter notebook integration with Spyder"
HOMEPAGE="https://github.com/spyder-ide/spyder-notebook"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/nbformat[${PYTHON_USEDEP}]
	>=dev-python/notebook-7[${PYTHON_USEDEP}]
	<dev-python/notebook-8[${PYTHON_USEDEP}]
	dev-python/qdarkstyle[${PYTHON_USEDEP}]
	dev-python/QtPy[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	>=dev-python/spyder-5.4.3[${PYTHON_USEDEP}]
	<dev-python/spyder-6[${PYTHON_USEDEP}]
	dev-python/tornado[${PYTHON_USEDEP}]
	dev-python/traitlets[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pytest-qt[${PYTHON_USEDEP}]
	)
"

DOCS=( "README.md" "CHANGELOG.md" )

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Hangs
	spyder_notebook/widgets/tests/test_main_widget.py::test_save_notebook
	spyder_notebook/widgets/tests/test_main_widget.py::test_new_notebook
	# Fails in sandbox
	spyder_notebook/tests/test_plugin.py::test_open_console_when_no_kernel
	spyder_notebook/widgets/tests/test_main_widget.py::test_shutdown_notebook_kernel
	spyder_notebook/widgets/tests/test_main_widget.py::test_file_in_temp_dir_deleted_after_notebook_closed
	# Some missing file
	spyder_notebook/widgets/tests/test_main_widget.py::test_open_notebook_in_non_ascii_dir
	spyder_notebook/widgets/tests/test_main_widget.py::test_close_nonexisting_notebook
)

python_test() {
	virtx epytest
}
