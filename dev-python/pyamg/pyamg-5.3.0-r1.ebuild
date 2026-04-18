# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_12 )

inherit distutils-r1

DESCRIPTION="Algebraic multigrid solvers in Python"
HOMEPAGE="
	https://github.com/pyamg/pyamg/
	https://pypi.org/project/pyamg/
"
SRC_URI="
	https://github.com/pyamg/pyamg/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-python/pybind11[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
"
RDEPEND="
	dev-python/cppheaderparser[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.11.0[${PYTHON_USEDEP}]
"
BDEPEND="
	${DEPEND}
	>=dev-python/setuptools-scm-7.0.0[${PYTHON_USEDEP}]
	test? (
		dev-python/matplotlib[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_prepare() {
	local PATCHES=(
		# https://github.com/pyamg/pyamg/commit/9f8299bcf1141e627503c3f208eda413bc1e28e6
		"${FILESDIR}/${P}-backport.patch"
	)

	distutils-r1_src_prepare

	# invalid with >=setuptools-scm-9
	sed -i -e '/version =/d' setup.cfg || die
}

python_test() {
	cd "${T}" || die
	epytest --pyargs pyamg
}
