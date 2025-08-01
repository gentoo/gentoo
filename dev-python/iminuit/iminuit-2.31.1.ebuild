# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=scikit-build-core
PYTHON_COMPAT=( python3_{11..13} )

inherit cmake distutils-r1 virtualx pypi

DESCRIPTION="Minuit numerical function minimization in Python"
HOMEPAGE="
	https://github.com/scikit-hep/iminuit/
	https://pypi.org/project/iminuit/
"

LICENSE="MIT LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
"
DEPEND="
	>=dev-python/pybind11-2.12[${PYTHON_USEDEP}]
"
BDEPEND="
	${DEPEND}
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		dev-python/annotated-types[${PYTHON_USEDEP}]
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/ipywidgets[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
EPYTEST_XDIST=1
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# precision error
	tests/test_cost.py::test_Template_with_model_2D

	# TODO
	tests/test_describe.py::test_with_pydantic_types
)

src_prepare() {
	distutils-r1_src_prepare

	# do not force LTO
	sed -i -e '/INTERPROCEDURAL_OPTIMIZATION/d' CMakeLists.txt || die
	# https://github.com/scikit-build/scikit-build-core/issues/912
	sed -i -e '/scikit-build-core/s:0\.10:0.8:' pyproject.toml || die
}

src_test() {
	virtx distutils-r1_src_test
}
