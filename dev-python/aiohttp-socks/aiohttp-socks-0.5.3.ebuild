# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

DESCRIPTION="SOCKS proxy connector for aiohttp"
HOMEPAGE="https://pypi.org/project/aiohttp-socks/"
SRC_URI="https://github.com/romis2012/aiohttp-socks/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# Tests require Internet access, also they started failing when run
# via ebuild (but work fine externally)
RESTRICT="test"

# TODO: optional dep on trio
RDEPEND="
	>=dev-python/aiohttp-2.3.2[${PYTHON_USEDEP}]
	>=dev-python/attrs-19.2.0[${PYTHON_USEDEP}]"
DEPEND="
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		net-proxy/3proxy
	)"

distutils_enable_tests pytest

src_prepare() {
	# TODO: reenable when trio is packaged
	rm tests/test_core_socks_async_trio.py || die
	distutils-r1_src_prepare
}

python_configure_all() {
	rm tests/3proxy/bin/*/* || die
	if use test; then
		ln -s "$(type -P 3proxy)" tests/3proxy/bin/linux/ || die
	fi
}
