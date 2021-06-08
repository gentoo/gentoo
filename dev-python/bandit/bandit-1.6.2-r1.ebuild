# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="A security linter from OpenStack Security"
HOMEPAGE="https://github.com/PyCQA/bandit"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	https://github.com/PyCQA/bandit/commit/45494c94d59eea5ddbe0204f3781b90108cbde30.patch -> ${P}_py38-1.patch
	https://github.com/PyCQA/bandit/commit/3d0824676974e7e2e9635c10bc4f12e261f1dbdf.patch -> ${P}_py38-2.patch
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~s390 x86"
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
	>=dev-python/pyyaml-5.3.1[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.20.0[${PYTHON_USEDEP}]"

python_prepare() {
	sed -i 's/yaml.load/yaml.safe_load/g' tests/unit/formatters/test_yaml.py || die
	eapply "${DISTDIR}/${P}_py38-1.patch"
	eapply "${DISTDIR}/${P}_py38-2.patch"
	distutils-r1_python_prepare_all
}

python_test() {
	distutils_install_for_testing
	stestr init
	stestr run || die
}
