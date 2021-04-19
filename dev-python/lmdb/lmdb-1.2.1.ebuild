# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Python bindings for the Lightning Database"
HOMEPAGE="https://github.com/jnwatson/py-lmdb/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="OPENLDAP"
SLOT="0"
KEYWORDS=""

RDEPEND="
	>=dev-db/lmdb-0.9.28:=
	$(python_gen_cond_dep '
		dev-python/cffi[${PYTHON_USEDEP}]
	' 'python*')"
DEPEND="${RDEPEND}"

distutils_enable_sphinx docs
distutils_enable_tests pytest

python_compile() {
	LMDB_FORCE_SYSTEM=1 distutils-r1_python_compile
}

python_test() {
	epytest tests
}

python_install() {
	# This is required when the CFFI extension is used (for PyPy3)
	LMDB_FORCE_SYSTEM=1 distutils-r1_python_install
}
