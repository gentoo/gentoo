# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Sans-I/O implementation of SOCKS4, SOCKS4A, and SOCKS5"
HOMEPAGE="
	https://github.com/sethmlarson/socksio/
	https://pypi.org/project/socksio/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

distutils_enable_tests pytest

src_prepare() {
	# remove coverage args for tests
	rm pytest.ini || die

	distutils-r1_src_prepare
}
