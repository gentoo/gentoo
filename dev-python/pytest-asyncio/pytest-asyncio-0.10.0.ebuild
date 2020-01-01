# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7} )
inherit distutils-r1

DESCRIPTION="Library for testing asyncio code with pytest"
HOMEPAGE="https://github.com/pytest-dev/pytest-asyncio
	https://pypi.org/project/pytest-asyncio/"
SRC_URI="https://github.com/pytest-dev/pytest-asyncio/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/async_generator[${PYTHON_USEDEP}]' \
		python3_5)"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/async_generator[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-3.64[${PYTHON_USEDEP}]
	)"

python_test() {
	distutils_install_for_testing
	pytest -vv || die "Tests fail with ${EPYTHON}"
}
