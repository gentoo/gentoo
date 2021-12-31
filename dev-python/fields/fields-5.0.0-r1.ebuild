# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} pypy pypy3 )
inherit distutils-r1

DESCRIPTION="Container class boilerplate killer"
HOMEPAGE="https://github.com/ionelmc/python-fields"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="test"

DEPEND="test? ( dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/characteristic[${PYTHON_USEDEP}] )"

RESTRICT="!test? ( test )"

python_prepare_all() {
	sed -i -e "/--benchmark-disable/d" setup.cfg || die
	rm -rf tests/test_perf.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	py.test -vv || die
}
