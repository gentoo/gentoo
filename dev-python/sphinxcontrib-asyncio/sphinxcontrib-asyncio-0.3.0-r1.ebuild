# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="sphinx extension to support coroutines in markup"
HOMEPAGE="
	https://github.com/aio-libs/sphinxcontrib-asyncio/
	https://pypi.org/project/sphinxcontrib-asyncio/
"

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
