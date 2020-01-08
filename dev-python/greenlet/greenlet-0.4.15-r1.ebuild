# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Note: greenlet is built-in in pypy
PYTHON_COMPAT=( python2_7 python3_{6,7,8} )

inherit distutils-r1 flag-o-matic

DESCRIPTION="Lightweight in-process concurrent programming"
HOMEPAGE="https://pypi.org/project/greenlet/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

DISTUTILS_IN_SOURCE_BUILD=1

distutils_enable_sphinx doc

python_compile() {
	if ! python_is_python3; then
		local CFLAGS=${CFLAGS} CXXFLAGS=${CXXFLAGS}
		append-flags -fno-strict-aliasing
	fi

	distutils-r1_python_compile
}

python_test() {
	"${PYTHON}" run-tests.py -n || die "Tests fail with ${EPYTHON}"
}
