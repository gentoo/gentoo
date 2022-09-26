# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="sphinx extension to support coroutines in markup"
HOMEPAGE="
	https://github.com/aio-libs/sphinxcontrib-asyncio/
	https://pypi.org/project/sphinxcontrib-asyncio/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/sphinx[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs

src_prepare() {
	rm sphinxcontrib/__init__.py || die
	distutils-r1_src_prepare
}
