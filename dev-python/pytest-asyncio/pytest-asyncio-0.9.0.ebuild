# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7} )

inherit distutils-r1

DESCRIPTION="Pytest support for asyncio"
HOMEPAGE="https://github.com/pytest-dev/pytest-asyncio https://pypi.org/project/pytest-asyncio/"
SRC_URI="https://github.com/pytest-dev/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/async_generator[${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"

python_test() {
	distutils_install_for_testing
	pytest -vv || die "Tests fail with ${EPYTHON}"
}
