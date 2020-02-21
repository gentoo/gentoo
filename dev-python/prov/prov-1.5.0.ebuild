# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="W3C provenance data dodel library"
HOMEPAGE="https://pypi.org/project/prov/"
SRC_URI="mirror://pypi/p/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-python/pydotplus[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	>=dev-python/networkx-1.10[${PYTHON_USEDEP}]
	dev-python/rdflib[${PYTHON_USEDEP}]
	>=dev-python/six-1.10[${PYTHON_USEDEP}]
"
DEPEND="
	test? ( ${RDEPEND} )
	dev-python/setuptools[${PYTHON_USEDEP}]
"

#the test phase fails due to a bug that may be better fixed
#in setuptools or the yajl package:
#https://github.com/gentoo/gentoo/pull/4346#issuecomment-291776642
RESTRICT="test"

python_test() {
	${EPYTHON} -m unittest discover || die
}
