# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Persistent/Functional/Immutable data structures"
HOMEPAGE="
	https://github.com/tobgu/pyrsistent/
	https://pypi.org/project/pyrsistent/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~x64-macos"
IUSE="+native-extensions"

BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_configure() {
	if ! use native-extensions; then
		export PYRSISTENT_SKIP_EXTENSION=1
	fi
}
