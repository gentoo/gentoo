# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{5,6,7}} pypy{,3} )

inherit distutils-r1

DESCRIPTION="virtualenv-based automation of test activities"
HOMEPAGE="https://tox.readthedocs.io https://github.com/tox-dev/tox https://pypi.org/project/tox/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# doc disabled because of missing deps in tree
IUSE="test"

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
	>=dev-python/setuptools_scm-2[${PYTHON_USEDEP}]
	test? (
		>=dev-python/freezegun-0.3.11[${PYTHON_USEDEP}]
		>=dev-python/pytest-3.6[${PYTHON_USEDEP}]
		<dev-python/pytest-4.0
		<dev-python/pytest-mock-2.0[${PYTHON_USEDEP}]
	)"

# for some reason, --deselect doesn't work in tox's tests
PATCHES=( "${FILESDIR}/${PN}-3.7.0-skip-broken-tests.patch" )

python_test() {
	pytest -v --no-network || die "Testsuite failed under ${EPYTHON}"
}
