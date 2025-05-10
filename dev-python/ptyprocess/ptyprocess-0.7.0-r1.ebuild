# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..14} python3_13t pypy3 pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Run a subprocess in a pseudo terminal"
HOMEPAGE="
	https://github.com/pexpect/ptyprocess/
	https://pypi.org/project/ptyprocess/
"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~x64-macos"

distutils_enable_tests unittest

src_prepare() {
	distutils-r1_src_prepare

	# https://github.com/pexpect/ptyprocess/pull/75
	sed -i -e '/makeSuite/d' tests/test_invalid_binary.py || die
}
