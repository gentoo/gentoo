# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python{2_7,3_{4,5,6,7}} )

inherit distutils-r1

MY_PN="${PN/-/.}"
DESCRIPTION="Objects and routines pertaining to date and time"
HOMEPAGE="https://github.com/jaraco/tempora"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

# The calc-prorate binary used to be part of jaraco.utils
RDEPEND="
	!<=dev-python/jaraco-utils-10.0.2
	>=dev-python/jaraco-functools-1.20[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="
	>=dev-python/setuptools_scm-1.15.0[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/jaraco-packaging-3.2[${PYTHON_USEDEP}]
		>=dev-python/rst-linker-1.9[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	test? (
		${RDEPEND}
		>=dev-python/pytest-2.8[${PYTHON_USEDEP}]
		dev-python/backports-unittest-mock[${PYTHON_USEDEP}]
		dev-python/freezegun[${PYTHON_USEDEP}]
	)
"

S="${WORKDIR}/${MY_PN}-${PV}"

python_compile_all() {
	if use doc; then
		sphinx-build docs docs/_build/html || die
		HTML_DOCS=( docs/_build/html/. )
	fi
}

python_test() {
	# Override pytest options to skip flake8
	PYTHONPATH=. pytest -vv --override-ini="addopts=--doctest-modules" \
		|| die "tests failed with ${EPYTHON}"
}
