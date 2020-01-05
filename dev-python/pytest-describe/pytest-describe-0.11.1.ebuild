# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Describe-style plugin for py.test"
HOMEPAGE="https://github.com/ropez/pytest-describe https://pypi.org/project/pytest-describe"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-python/pytest-2.6.0[${PYTHON_USEDEP}]"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( >=dev-python/pytest-2.6.0[${PYTHON_USEDEP}] )"

python_test() {
	# We need to disable some plugins because tests don't like unexpected
	# output
	PYTEST_ADDOPTS="-p no:flaky -p no:capturelog" pytest -vv || die "Tests failed under ${EPYTHON}"
}
