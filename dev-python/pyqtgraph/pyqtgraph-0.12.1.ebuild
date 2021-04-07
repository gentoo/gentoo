# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1 multiprocessing virtualx

TEST_DATA_TAG=test-data-8
DESCRIPTION="A pure-python graphics and GUI library built on PyQt and numpy"
HOMEPAGE="http://www.pyqtgraph.org/ https://pypi.org/project/pyqtgraph/"
SRC_URI="
	https://github.com/pyqtgraph/pyqtgraph/archive/${P}.tar.gz
	test? (
		https://github.com/pyqtgraph/test-data/archive/${TEST_DATA_TAG}.tar.gz
			-> ${PN}-${TEST_DATA_TAG}.tar.gz
	)"
S=${WORKDIR}/${PN}-${P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples opengl svg"

RDEPEND="
	>=dev-python/numpy-1.17[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/PyQt5[gui,widgets,opengl=,svg=,${PYTHON_USEDEP}]
	opengl? ( dev-python/pyopengl[${PYTHON_USEDEP}] )"
BDEPEND="
	test? (
		dev-python/h5py[${PYTHON_USEDEP}]
		dev-python/PyQt5[svg,testlib,${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-vcs/git
	)"

distutils_enable_sphinx doc/source
distutils_enable_tests pytest

python_prepare_all() {
	distutils-r1_python_prepare_all

	if use test; then
		mkdir "${HOME}"/.pyqtgraph || die
		mv "${WORKDIR}/test-data-${TEST_DATA_TAG}" \
			"${HOME}"/.pyqtgraph/test-data || die
		cd "${HOME}"/.pyqtgraph/test-data || die
		# we need to fake a git repo
		git config --global user.email "you@example.com"
		git config --global user.name "Your Name"
		git init -q || die
		git commit -q --allow-empty -m "dummy commit" || die
		git tag "${TEST_DATA_TAG}" || die
		cd - >/dev/null || die
	fi
	if ! use opengl; then
		rm -r pyqtgraph/opengl || die
	fi
}

python_test() {
	local deselect=(
		# apparently fragile
		--deselect pyqtgraph/tests/test_reload.py::test_reload

		# pyside2 is normally skipped if not installed but these two
		# fail if it is installed
		# TODO: this could be due to USE flags, revisit when pyside2
		# gains py3.9
		--deselect
		'examples/test_examples.py::testExamples[ DateAxisItem_QtDesigner.py - PySide2 ]'
		--deselect
		'examples/test_examples.py::testExamples[ designerExample.py - PySide2 ]'
	)

	distutils_install_for_testing
	virtx epytest "${deselect[@]}" \
		-n "$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")"
}

python_install_all() {
	use examples && DOCS+=( examples/ )
	distutils-r1_python_install_all
}
