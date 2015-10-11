# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="The new features in unittest backported to Python 2.4+"
HOMEPAGE="https://pypi.python.org/pypi/unittest2"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/linecache2[${PYTHON_USEDEP}]
	>=dev-python/six-1.4[${PYTHON_USEDEP}]
	dev-python/traceback2[${PYTHON_USEDEP}]
"
DEPEND="${CDEPEND}"
RDEPEND="${CDEPEND}"

PATCHES=( "${FILESDIR}"/remove-argparse-dependence.patch )

python_test() {
	"${PYTHON}" -m unittest2 discover || die "tests failed under ${EPYTHON}"
}
