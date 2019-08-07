# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="SOCKS proxy connector for aiohttp"
HOMEPAGE="https://pypi.org/project/aiohttp-socks/"
SRC_URI="https://github.com/romis2012/aiohttp-socks/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
# Tests require Internet access
RESTRICT="test"

RDEPEND=">=dev-python/aiohttp-2.3.2[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		net-proxy/3proxy
	)"

python_configure_all() {
	rm tests/3proxy/bin/*/* || die
	if use test; then
		ln -s "$(type -P 3proxy)" tests/3proxy/bin/linux/ || die
	fi
}

python_test() {
	pytest -vv || die "Tests fail with ${EPYTHON}"
}
