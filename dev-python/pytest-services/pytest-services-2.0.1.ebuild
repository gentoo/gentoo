# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
inherit distutils-r1

DESCRIPTION="Collection of fixtures and utility functions to run service processes for pytest"
HOMEPAGE="https://github.com/pytest-dev/pytest-services"
SRC_URI="https://github.com/pytest-dev/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="dev-python/requests[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/zc-lockfile[${PYTHON_USEDEP}]"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pylibmc[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/subprocess32[${PYTHON_USEDEP}]' -2)
	)"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/pytest-services-2.0.1-no-mysql.patch"
	"${FILESDIR}/pytest-services-2.0.1-lockdir.patch"
)

python_test() {
	distutils_install_for_testing
	pytest -vv tests || die "Tests failed under ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install

	find "${D}" -name '*.pth' -delete || die
}
