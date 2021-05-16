# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} pypy3 )
inherit distutils-r1

EGIT_COMMIT=17a5d207f603c0c142f01a69fbf6f487b3fef5c4
DESCRIPTION="Simple lru_cache for asyncio"
HOMEPAGE="
	https://github.com/aio-libs/async-lru/
	https://pypi.org/project/async_lru/"
SRC_URI="
	https://github.com/aio-libs/async-lru/archive/${EGIT_COMMIT}.tar.gz
		-> ${PN}-${EGIT_COMMIT}.tar.gz"
S=${WORKDIR}/${PN}-${EGIT_COMMIT}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	test? (
		<dev-python/pytest-6.2[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

src_prepare() {
	sed -e 's:--cache-clear::' \
		-e 's:--no-cov-on-fail --cov=async_lru --cov-report=term --cov-report=html::' \
		-i setup.cfg || die

	distutils-r1_src_prepare
}
