# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=meson-python
PYPI_VERIFY_REPO=https://github.com/pyamg/pyamg
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Algebraic multigrid solvers in Python"
HOMEPAGE="
	https://github.com/pyamg/pyamg/
	https://pypi.org/project/pyamg/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-python/pybind11-2.12.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-2.0.0[${PYTHON_USEDEP}]
"
RDEPEND="
	dev-python/cppheaderparser[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.23.5[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.15.0[${PYTHON_USEDEP}]
"
BDEPEND="
	${DEPEND}
	dev-python/versioningit[${PYTHON_USEDEP}]
	test? (
		dev-python/matplotlib[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	cd "${T}" || die
	epytest --pyargs pyamg
}
