# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_5,3_6} pypy{,3} )

inherit distutils-r1

DESCRIPTION="A simple and pragmatic library which accesses the Neo4j graph database"
HOMEPAGE="https://py2neo.org/v3/"
SRC_URI="mirror://pypi/p/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_compile() {
	# https://github.com/nigelsmall/py2neo/issues/380
	python_is_python3 || local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
	distutils-r1_python_compile
}
