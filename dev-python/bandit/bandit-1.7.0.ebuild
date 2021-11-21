# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="A security linter from OpenStack Security"
HOMEPAGE="https://github.com/PyCQA/bandit"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~s390 x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/coverage-4.5.4[${PYTHON_USEDEP}]
		>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/hacking-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/mock-3.0.5[${PYTHON_USEDEP}]
		>=dev-python/stestr-2.5.0
		>=dev-python/testscenarios-0.5.0[${PYTHON_USEDEP}]
		>=dev-python/testtools-2.3.0[${PYTHON_USEDEP}]
		>=dev-python/beautifulsoup4-4.8.0[${PYTHON_USEDEP}]
		>=dev-python/pylint-1.9.4[${PYTHON_USEDEP}]
	)"
RDEPEND="
	>=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/GitPython-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.3.1[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.20.0[${PYTHON_USEDEP}]"

src_prepare() {
	sed -i 's/yaml.load/yaml.safe_load/g' tests/unit/formatters/test_yaml.py || die
	distutils-r1_src_prepare
}

python_test() {
	distutils_install_for_testing
	stestr init
	stestr run || die
}
