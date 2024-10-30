# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Bindings for the scrypt key derivation function library"
HOMEPAGE="
	https://github.com/holgern/py-scrypt/
	https://pypi.org/project/scrypt/
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

DEPEND="
	dev-libs/openssl:0=
"
RDEPEND="
	${DEPEND}
"

distutils_enable_tests unittest
