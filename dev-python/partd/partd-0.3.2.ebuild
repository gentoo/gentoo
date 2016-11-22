# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1

DESCRIPTION="Appendable key-value storage"
HOMEPAGE="https://github.com/dask/partd/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"

RDEPEND="dev-python/locket[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
	  dev-python/blosc[${PYTHON_USEDEP}]
	  dev-python/numpy[${PYTHON_USEDEP}]
	  dev-python/pandas[${PYTHON_USEDEP}]
	  dev-python/pytest[${PYTHON_USEDEP}]
	  dev-python/pyzmq[${PYTHON_USEDEP}]
	  dev-python/toolz[${PYTHON_USEDEP}] )"

python_test() {
	py.test partd --verbose || die
}
