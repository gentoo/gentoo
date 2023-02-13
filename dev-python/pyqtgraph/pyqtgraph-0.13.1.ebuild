# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..10} )

inherit distutils-r1 multiprocessing

DESCRIPTION="A pure-python graphics and GUI library built on PyQt and numpy"
HOMEPAGE="
	https://www.pyqtgraph.org/
	https://github.com/pyqtgraph/pyqtgraph/
	https://pypi.org/project/pyqtgraph/
"
SRC_URI="
	https://github.com/pyqtgraph/pyqtgraph/archive/${P}.tar.gz
		-> ${P}.gh.tar.gz
"
S=${WORKDIR}/${PN}-${P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~riscv x86"
IUSE="opengl svg"
REQUIRED_USE="test? ( opengl svg )"

RDEPEND="
	>=dev-python/numpy-1.17[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/PyQt5[gui,widgets,opengl=,svg=,${PYTHON_USEDEP}]
	opengl? ( dev-python/pyopengl[${PYTHON_USEDEP}] )
"
BDEPEND="
	test? (
		dev-python/h5py[${PYTHON_USEDEP}]
		dev-python/PyQt5[testlib,${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/pytest-xvfb[${PYTHON_USEDEP}]
		dev-vcs/git
	)
"

distutils_enable_sphinx doc/source
distutils_enable_tests pytest

python_prepare_all() {
	distutils-r1_python_prepare_all

	if ! use opengl; then
		rm -r pyqtgraph/opengl || die
	fi
}

python_test() {
	local EPYTEST_DESELECT=(
		# apparently fragile
		tests/test_reload.py::test_reload

		# TODO
		tests/graphicsItems/test_ROI.py::test_PolyLineROI

		# pyside2 is normally skipped if not installed but these two
		# fail if it is installed
		# TODO: this could be due to USE flags, revisit when pyside2
		# gains py3.9
		'pyqtgraph/examples/test_examples.py::testExamples[ DateAxisItem_QtDesigner.py - PySide2 ]'
		'pyqtgraph/examples/test_examples.py::testExamples[ designerExample.py - PySide2 ]'
	)

	epytest -p xvfb -n "$(makeopts_jobs)"
}
