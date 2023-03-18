# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Asyncio cache manager"
HOMEPAGE="https://github.com/aio-libs/aiocache/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# TODO add optional cache systems deps (and new package aiomcache)
# Tests require all backends
RESTRICT="test"

BDEPEND="
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
	)"

PATCHES=( "${FILESDIR}/${PN}-0.12.0-fix-test-installation.patch" )

distutils_enable_tests pytest

python_test() {
	epytest -o addopts=
}
