# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="A security linter from OpenStack Security"
HOMEPAGE="https://github.com/PyCQA/bandit"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~s390 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/coverage-4.0[${PYTHON_USEDEP}]
		!~dev-python/coverage-4.4[${PYTHON_USEDEP}]
		>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/hacking-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/stestr-1.0.0
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
		>=dev-python/testtools-2.2.0[${PYTHON_USEDEP}]
		>=dev-python/oslotest-3.2.0[${PYTHON_USEDEP}]
		>=dev-python/beautifulsoup-4.6.0[${PYTHON_USEDEP}]
		>=dev-python/pylint-1.4.5[${PYTHON_USEDEP}]
	)"
RDEPEND="
	>=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/GitPython-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.13.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.20.0[${PYTHON_USEDEP}]"

python_test() {
	stestr init
	stestr run || die
}
