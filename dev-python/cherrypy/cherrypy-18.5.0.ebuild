# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

MY_P="CherryPy-${PV}"

DESCRIPTION="CherryPy is a pythonic, object-oriented HTTP framework"
HOMEPAGE="https://www.cherrypy.org https://pypi.org/project/CherryPy/"
SRC_URI="mirror://pypi/C/CherryPy/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ia64 ~ppc ~ppc64 ~x86"
IUSE="ssl test"

RDEPEND=">=dev-python/cheroot-8.2.1[${PYTHON_USEDEP}]
	>=dev-python/portend-2.1.1[${PYTHON_USEDEP}]
	dev-python/more-itertools[${PYTHON_USEDEP}]
	dev-python/zc-lockfile[${PYTHON_USEDEP}]
	dev-python/jaraco-collections[${PYTHON_USEDEP}]
	ssl? ( dev-python/pyopenssl[${PYTHON_USEDEP}] )"
BDEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/routes[${PYTHON_USEDEP}]
		dev-python/simplejson[${PYTHON_USEDEP}]
		dev-python/objgraph[${PYTHON_USEDEP}]
		dev-python/backports-unittest-mock[${PYTHON_USEDEP}]
		dev-python/path-py[${PYTHON_USEDEP}]
		dev-python/requests-toolbelt[${PYTHON_USEDEP}]
		dev-python/pytest-services[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/cherrypy-18.5.0-tests.patch"
)

distutils_enable_tests pytest

python_prepare_all() {
	# UnicodeEncodeError: 'ascii' codec can't encode character u'\u2603' in position 0: ordinal not in range(128)
	sed -e 's|@pytest.mark.xfail(py27_on_windows|@pytest.mark.xfail(sys.version_info < (3,)|' \
		-i cherrypy/test/test_static.py || die

	sed -r -e '/(pytest-sugar|pytest-cov)/ d' \
		-i setup.py || die

	sed -r -e 's:--cov-report[[:space:]]+[[:graph:]]+::g' \
		-e 's:--cov[[:graph:]]+::g' \
		-e 's:--doctest[[:graph:]]+::g' \
		-i pytest.ini || die

	distutils-r1_python_prepare_all
}
