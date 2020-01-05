# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{6,7,8}} pypy3 )

inherit distutils-r1

DESCRIPTION="py.test plugin for coverage reporting"
HOMEPAGE="https://github.com/pytest-dev/pytest-cov https://pypi.org/project/pytest-cov/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/py-1.4.22[${PYTHON_USEDEP}]
	>=dev-python/pytest-3.6[${PYTHON_USEDEP}]
	>=dev-python/coverage-4.4[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/virtualenv[${PYTHON_USEDEP}]
		dev-python/fields[${PYTHON_USEDEP}]
		>=dev-python/process-tests-2.0.2[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	# Bug 597708
	"${FILESDIR}/${PN}-2.8.1-disable-broken-tests.patch"
	"${FILESDIR}/${PN}-2.8.1-latest-setuptools.patch"
	# https://github.com/pytest-dev/pytest-cov/issues/365
	"${FILESDIR}/pytest-cov-2.8.1-python38.patch"
)

distutils_enable_sphinx docs \
	dev-python/sphinx-py3doc-enhanced-theme

python_test() {
	distutils_install_for_testing
	PYTHONPATH="${S}/tests:${BUILD_DIR}/lib:${PYTHONPATH}" \
		PYTEST_PLUGINS=${PN/-/_} \
		pytest -vv || die "Tests failed under ${EPYTHON}"
}
