# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Library for testing asyncio code with pytest"
HOMEPAGE="https://github.com/pytest-dev/pytest-asyncio
	https://pypi.org/project/pytest-asyncio/"
SRC_URI="https://github.com/pytest-dev/pytest-asyncio/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/pytest-5.4.0"
BDEPEND="
	test? (
		dev-python/async_generator[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-3.64[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

python_test() {
	distutils_install_for_testing
	pytest -vv || die "Tests fail with ${EPYTHON}"
}
