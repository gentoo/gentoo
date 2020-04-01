# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1

MY_PV="${PV//_p/.post}"
DESCRIPTION="Machine learning library for Python"
HOMEPAGE="https://scikit-learn.org/stable/
	https://github.com/scikit-learn/scikit-learn"
SRC_URI="https://github.com/${PN}/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/wheel[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}
	test? (
		dev-python/joblib[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	distutils_install_for_testing
	pushd "${TEST_DIR}/lib" >/dev/null || die
	pytest -vv || die "testing failed with ${EPYTHON}"
	popd >/dev/null || die
}
