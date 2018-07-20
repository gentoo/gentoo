# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="Mutable mapping tools"
HOMEPAGE="https://github.com/dask/zict/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="dev-python/HeapDict[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
	   dev-python/HeapDict[${PYTHON_USEDEP}]
	   dev-python/lmdb[${PYTHON_USEDEP}]
	   dev-python/pytest[${PYTHON_USEDEP}]
	)
"

python_test() {
	py.test || die
}
