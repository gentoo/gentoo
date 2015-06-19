# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/tabulate/tabulate-0.7.3.ebuild,v 1.1 2015/01/26 07:53:31 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 python{3_3,3_4} )

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
	test? ( virtual/funcsigs[${PYTHON_USEDEP}] )
"

# Missing something:
#
# from common import assert_equal
RESTRICT=test

python_test() {
	local testcase
	for testcase in test/*py; do
		${PYTHON} ${testcase} || die
	done
}
