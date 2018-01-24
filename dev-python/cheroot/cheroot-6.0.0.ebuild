# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Cheroot is the high-performance, pure-Python HTTP server used by CherryPy."
HOMEPAGE="http://www.cherrypy.org/ https://pypi.python.org/pypi/Cheroot https://github.com/cherrypy/cheroot"
SRC_URI="mirror://pypi/C/${PN/c/C}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~x86"
IUSE="test"

RDEPEND=">=dev-python/six-1.11.0[${PYTHON_USEDEP}]
	>=dev-python/more-itertools-2.6[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm-1.15.0[${PYTHON_USEDEP}]
	test? (
		dev-python/portend[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
	)"

python_test() {
	py.test -v || die "tests failed under ${EPTYHON}"
}
