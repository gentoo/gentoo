# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7} pypy3 )

inherit distutils-r1

DESCRIPTION="Cheroot is the high-performance, pure-Python HTTP server used by CherryPy."
HOMEPAGE="https://cherrypy.org/ https://pypi.org/project/Cheroot/ https://github.com/cherrypy/cheroot"
SRC_URI="mirror://pypi/C/${PN/c/C}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
# Unit tests are temporarily disabled for this version, see below for
# what needs to be done.
# IUSE="test"
RESTRICT="test"

RDEPEND=">=dev-python/six-1.11.0[${PYTHON_USEDEP}]
	>=dev-python/more-itertools-2.6[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	<dev-python/setuptools-41.4.0[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm-1.15.0[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm_git_archive-1.0[${PYTHON_USEDEP}]"

	# Add the following for unit tests, some packages listed will need
	# to be added and keyworded appropriately.
#	test? (
#	dev-python/ddt[${PYTHON_USEDEP}]
#		dev-python/pytest[${PYTHON_USEDEP}]
#		dev-python/pytest-mock[${PYTHON_USEDEP}]
#		dev-python/pytest-sugar[${PYTHON_USEDEP}]
#		dev-python/pytest-testmon[${PYTHON_USEDEP}]
#		dev-python/pytest-watch[${PYTHON_USEDEP}]
#		dev-python/pytest-xdist[${PYTHON_USEDEP}]
#		dev-python/coverage[${PYTHON_USEDEP}]
#		dev-python/codecov[${PYTHON_USEDEP}]
#		dev-python/pytest-cov[${PYTHON_USEDEP}]
#		dev-python/trustme[${PYTHON_USEDEP}]
#		dev-python/pyopenssl[${PYTHON_USEDEP}]
#		dev-python/requests-unixsocket[${PYTHON_USEDEP}]
#	)"

PATCHES=(
	# https://github.com/CherryPy/cheroot/issues/181
	"${FILESDIR}"/6.5.4-fix-requirements.patch
)

# python_test() {
#	py.test -v || die "tests failed under ${EPYTHON}"
# }
