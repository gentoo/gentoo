# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Generator-based operators for asynchronous iteration"
HOMEPAGE="
	https://pypi.org/project/aiostream/
	https://github.com/vxgmichel/aiostream/
"
SRC_URI="
	https://github.com/vxgmichel/aiostream/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e 's:--cov aiostream --cov-report html --cov-report term::' \
		setup.cfg || die
	distutils-r1_src_prepare
}
