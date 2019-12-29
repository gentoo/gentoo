# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7} )
inherit distutils-r1

DESCRIPTION="take TDD to a new level with py.test and testmon"
HOMEPAGE="https://github.com/tarpas/pytest-testmon"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/pytest[${PYTHON_USEDEP}]
dev-python/coverage[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	distutils_install_for_testing
	py.test -v || die "Tests fail with ${EPYTHON}"
}
