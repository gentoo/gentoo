# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
# Disable PyPy3 for now because it is not stable enough:
# https://github.com/wbolster/plyvel/issues/140
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Python interface to LevelDB"
HOMEPAGE="
	https://github.com/wbolster/plyvel/
	https://pypi.org/project/plyvel/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=dev-libs/leveldb-1.21:=
"
RDEPEND="
	${DEPEND}
"

distutils_enable_sphinx doc
distutils_enable_tests pytest

python_test() {
	rm -rf plyvel || die
	epytest
}
