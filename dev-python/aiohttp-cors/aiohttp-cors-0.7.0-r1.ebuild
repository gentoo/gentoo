# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Implements CORS support for aiohttp asyncio-powered asynchronous HTTP server"
HOMEPAGE="https://github.com/aio-libs/aiohttp-cors"
SRC_URI="https://github.com/aio-libs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-python/aiohttp-1.1.1[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/pytest-aiohttp[${PYTHON_USEDEP}]
		dev-python/selenium[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

# https://github.com/aio-libs/aiohttp-cors/pull/278
PATCHES=(
	"${FILESDIR}/${P}-tests.patch"
	"${FILESDIR}/${P}-py3_7.patch"
)

src_prepare() {
	sed -i -e '/^addopts=/d' setup.cfg || die
	echo "    ignore::DeprecationWarning" >> pytest.ini
	distutils-r1_src_prepare
}
