# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Python bindings for the Lightning Database"
HOMEPAGE="
	https://github.com/jnwatson/py-lmdb/
	https://pypi.org/project/lmdb/
"

LICENSE="OPENLDAP"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv x86 ~amd64-linux ~x86-linux"

# cffi is used only on pypy, so no dep
DEPEND="
	>=dev-db/lmdb-0.9.28:=
"
RDEPEND="
	${DEPEND}
"

distutils_enable_tests pytest

src_compile() {
	local -x LMDB_FORCE_SYSTEM=1
	distutils-r1_src_compile
}

python_test() {
	rm -rf lmdb || die
	epytest tests
}
