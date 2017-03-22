# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# It is the developer's intention that backports.unittest_mock will be
# used even for Python 3: https://github.com/jaraco/jaraco.timing/pull/1
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

MY_PN="${PN/-/.}"
MY_PN="${MY_PN//-/_}"
DESCRIPTION="Backport of unittest.mock"
HOMEPAGE="https://github.com/jaraco/backports.unittest_mock"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 hppa ppc64 ~x86"
IUSE="doc test"

RDEPEND="dev-python/mock[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm-1.15.0[${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/rst-linker[${PYTHON_USEDEP}]
	)
	test? (
		${RDEPEND}
		>=dev-python/pytest-2.8[${PYTHON_USEDEP}]
		dev-python/pytest-runner[${PYTHON_USEDEP}]
	)
"

S="${WORKDIR}/${MY_PN}-${PV}"

python_compile_all() {
	if use doc; then
		cd docs || die
		sphinx-build . _build/html || die
		HTML_DOCS=( docs/_build/html/. )
	fi
}

python_test() {
	py.test || die "tests failed with ${EPYTHON}"
}
