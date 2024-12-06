# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

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
KEYWORDS="amd64 ~arm arm64 ~riscv ~x86"
IUSE="opengl pyside6 qt5 +qt6 svg"
REQUIRED_USE="test? ( opengl svg )"

RDEPEND="
	>=dev-python/numpy-1.22[${PYTHON_USEDEP}]
	dev-python/pyqt6[gui,widgets,opengl=,svg=,${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	opengl? ( dev-python/pyopengl[${PYTHON_USEDEP}] )
"
BDEPEND="
	test? (
		dev-python/h5py[${PYTHON_USEDEP}]
		dev-python/pyqt6[testlib,${PYTHON_USEDEP}]
		dev-python/pytest-xvfb[${PYTHON_USEDEP}]
		dev-vcs/git
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

python_prepare_all() {
	distutils-r1_python_prepare_all

	if ! use opengl; then
		rm -r pyqtgraph/opengl || die
	fi

	# pyqtgraph will automatically use any QT bindings it finds,
	# Since we only want qt6, hardcode this where upstream allows an envvar to pick.
	sed -i "s/QT_LIB = os.getenv('PYQTGRAPH_QT_LIB')/QT_LIB = 'PyQt6'/" pyqtgraph/Qt/__init__.py ||
		die "Failed to set QT_LIB"

	# We only want to run tests for qt6 so don't try other frontends if they're installed.
	if use test; then
		awk -i inplace '
		/frontends = {/ {
			i = 6 # length of frontends

		print "frontends = {"
		print "    Qt.PYQT6: False,"
		print "}"
		}
		i > 0 {
			i--
			next
		}
		{ print }
		' pyqtgraph/examples/test_examples.py || die "Failed to patch test frontends"
	fi
}

python_test() {
	local EPYTEST_DESELECT=(
		# apparently fragile
		tests/test_reload.py::test_reload

		# TODO
		tests/exporters/test_svg.py::test_plotscene
		tests/graphicsItems/test_ROI.py::test_PolyLineROI

		# pyside2 is normally skipped if not installed but these two
		# fail if it is installed
		# TODO: this could be due to USE flags, revisit when pyside2
		# gains py3.9
		'pyqtgraph/examples/test_examples.py::testExamples[ DateAxisItem_QtDesigner.py - PySide2 ]'
		'pyqtgraph/examples/test_examples.py::testExamples[ designerExample.py - PySide2 ]'
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p xvfb
}
