# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/unittest2/unittest2-1.0.1.ebuild,v 1.3 2015/04/02 19:54:07 maekke Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 python3_3 python3_4 )

inherit distutils-r1

DESCRIPTION="The new features in unittest for Python 2.7 backported to Python 2.4+"
HOMEPAGE="http://pypi.python.org/pypi/unittest2"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa"
IUSE=""

CDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/traceback2[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/linecache2[${PYTHON_USEDEP}]
	${CDEPEND}
"
RDEPEND="${CDEPEND}"

python_prepare_all() {
	ebegin 'patching setup.py'
	sed \
		-e "60 s/'argparse', //" \
		-i setup.py
	STATUS=${?}
	eend ${STATUS}
	[[ ${STATUS} -gt 0 ]] && die

	distutils-r1_python_prepare_all
}

python_test() {
	"${PYTHON}" -m unittest2 discover || die "tests failed under ${EPYTHON}"
}
