# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy pypy3 )

inherit distutils-r1

MY_P="CherryPy-${PV}"

DESCRIPTION="CherryPy is a pythonic, object-oriented HTTP framework"
HOMEPAGE="http://www.cherrypy.org/ https://pypi.python.org/pypi/CherryPy"
SRC_URI="mirror://pypi/C/CherryPy/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~x86"
IUSE="test"

RDEPEND=">=dev-python/cheroot-5.9.1[${PYTHON_USEDEP}]
	>=dev-python/portend-2.1.1[${PYTHON_USEDEP}]
	>=dev-python/six-1.11.0[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/backports-unittest-mock[${PYTHON_USEDEP}]
		dev-python/path-py[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
	)"
S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	# UnicodeEncodeError: 'ascii' codec can't encode character u'\u2603' in position 0: ordinal not in range(128)
	sed -e 's|@pytest.mark.xfail(py27_on_windows|@pytest.mark.xfail(sys.version_info < (3,)|' \
		-i cherrypy/test/test_static.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	py.test -v || die "tests failed under ${EPTYHON}"
}
