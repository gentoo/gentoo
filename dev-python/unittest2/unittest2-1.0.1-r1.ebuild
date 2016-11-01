# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python3_4 pypy )

inherit distutils-r1

DESCRIPTION="The new features in unittest for Python 2.7 backported to Python 2.4+"
HOMEPAGE="https://pypi.python.org/pypi/unittest2"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc64 ~sparc"
IUSE=""

CDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/traceback2[${PYTHON_USEDEP}]
"
DEPEND="${CDEPEND}"
RDEPEND="${CDEPEND}"

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}"/remove-argparse-dependence.patch
	)

	distutils-r1_python_prepare_all
}

python_test() {
	"${PYTHON}" -m unittest2 discover || die "tests failed under ${EPYTHON}"
}
