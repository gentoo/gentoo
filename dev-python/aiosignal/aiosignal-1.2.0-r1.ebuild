# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="A list of registered asynchronous callbacks"
HOMEPAGE="
	https://pypi.org/project/aiosignal/
	https://github.com/aio-libs/aiosignal/
"
SRC_URI="
	https://github.com/aio-libs/aiosignal/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	>=dev-python/frozenlist-1.1.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/addopts/d' pytest.ini || die
	distutils-r1_src_prepare
}
