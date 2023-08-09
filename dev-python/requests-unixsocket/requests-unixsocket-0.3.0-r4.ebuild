# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Use requests to talk HTTP via a UNIX domain socket"
HOMEPAGE="
	https://github.com/msabramo/requests-unixsocket/
	https://pypi.org/project/requests-unixsocket/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/pbr[${PYTHON_USEDEP}]
	test? (
		dev-python/waitress[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	# https://github.com/msabramo/requests-unixsocket/pull/69
	"${FILESDIR}/${P}-urllib3-2.patch"
)

distutils_enable_tests pytest
