# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} pypy3 )

inherit distutils-r1

DESCRIPTION="virtualenv-based automation of test activities"
HOMEPAGE="https://tox.readthedocs.io https://github.com/tox-dev/tox https://pypi.org/project/tox/"
SRC_URI="https://github.com/tox-dev/tox/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm64 ~ia64 ~mips ~sparc ~x86"

# doc disabled because of missing deps in tree
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/filelock[${PYTHON_USEDEP}]
	<dev-python/pluggy-1.0[${PYTHON_USEDEP}]
	dev-python/pip[${PYTHON_USEDEP}]
	dev-python/py[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
	dev-python/virtualenv[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? (
		>=dev-python/flaky-3.4.0[${PYTHON_USEDEP}]
		<dev-python/flaky-4
		>=dev-python/freezegun-0.3.11[${PYTHON_USEDEP}]
		dev-python/pathlib2[${PYTHON_USEDEP}]
		>=dev-python/pytest-3.6[${PYTHON_USEDEP}]
		<dev-python/pytest-mock-2.0[${PYTHON_USEDEP}]
	)"

# for some reason, --deselect doesn't work in tox's tests
PATCHES=(
	"${FILESDIR}/${PN}-3.12.1-skip-broken-tests.patch"
	"${FILESDIR}/${PN}-3.9.0-strip-setuptools_scm.patch"
)

python_test() {
	distutils_install_for_testing
	pytest -v --no-network || die "Testsuite failed under ${EPYTHON}"
}
