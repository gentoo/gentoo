# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="Pretty-print tabular data"
HOMEPAGE="https://pypi.python.org/pypi/tabulate"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	test? ( virtual/python-funcsigs[${PYTHON_USEDEP}] )
"

# Missing something in tarball
#
# from common import assert_equal
RESTRICT=test

python_test() {
	local testcase
	for testcase in test/*py; do
		${PYTHON} ${testcase} || die
	done
}
