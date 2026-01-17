# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/aio-libs/aiodns
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Simple DNS resolver for asyncio"
HOMEPAGE="
	https://pypi.org/project/aiodns/
	https://github.com/aio-libs/aiodns/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
# Tests fail with network-sandbox, since they try to resolve google.com
PROPERTIES="test? ( test_network )"
RESTRICT="test"

RDEPEND="<dev-python/pycares-5[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

EPYTEST_PLUGINS=( pytest-asyncio )
distutils_enable_tests pytest

python_test() {
	epytest --asyncio-mode=auto
}
