# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend
# force it to match scikit-build
CMAKE_MAKEFILE_GENERATOR=ninja

inherit cmake distutils-r1

DESCRIPTION="Line-by-line profiler"
HOMEPAGE="https://github.com/pyutils/line_profiler/"
SRC_URI="
	https://github.com/pyutils/line_profiler/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/ipython[${PYTHON_USEDEP}]"
# technically, the package claims to support non-scikit-build build
# but it's clearly unmaintained and broken at the moment
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/scikit-build[${PYTHON_USEDEP}]
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/ubelt[${PYTHON_USEDEP}]
	)"

distutils_enable_tests --install pytest

src_prepare() {
	cmake_src_prepare
	distutils-r1_src_prepare
}

python_test() {
	distutils_install_for_testing
	cd tests || die
	epytest
}

python_install() {
	distutils-r1_python_install
	python_optimize
}
