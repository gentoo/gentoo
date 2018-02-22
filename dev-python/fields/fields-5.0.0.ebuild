# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python{3_4,3_5,3_6} pypy{,3} )
inherit distutils-r1

DESCRIPTION="Container class boilerplate killer"
HOMEPAGE="https://github.com/ionelmc/python-fields"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
IUSE="test"

DEPEND="test? ( dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/characteristic[${PYTHON_USEDEP}] )"

python_prepare_all() {
	sed -i -e "/--benchmark-disable/d" setup.cfg || die
	rm -rf tests/test_perf.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	py.test -vv || die
}
