# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} )
inherit distutils-r1

DESCRIPTION="Enables American fuzzy lop fork server and instrumentation for pure-Python code"
HOMEPAGE="https://github.com/jwilk/python-afl http://jwilk.net/software/python-afl"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="app-forensics/afl"
DEPEND=">=dev-python/cython-0.19[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

python_test() {
	PATH="${PATH}:." nosetests --verbose || die
}
