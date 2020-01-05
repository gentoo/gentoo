# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7} pypy3 )

inherit distutils-r1

DESCRIPTION="Cheroot is the high-performance, pure-Python HTTP server used by CherryPy."
HOMEPAGE="https://cherrypy.org/ https://pypi.org/project/Cheroot/ https://github.com/cherrypy/cheroot"
SRC_URI="mirror://pypi/C/${PN/c/C}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"
# Unit tests are temporarily disabled for this version, see below for
# what needs to be done.
#IUSE="test"
RESTRICT="test"

RDEPEND=">=dev-python/six-1.11.0[${PYTHON_USEDEP}]
	>=dev-python/more-itertools-2.6[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm-1.15.0[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm_git_archive-1.0[${PYTHON_USEDEP}]"

	# Add the following for unit tests, some packages listed will need
	# to be added and keyworded appropriately.
#	test? (
#		>=dev-python/pytest-2.8[${PYTHON_USEDEP}]
#		>=dev-python/pytest-mock-1.11.0[${PYTHON_USEDEP}]
#		>=dev-python/pytest-sugar-0.9.1[${PYTHON_USEDEP}]
#		>=dev-python/pytest-testmon-0.9.7[${PYTHON_USEDEP}]
#		~dev-python/pytest-watch-4.2.0[${PYTHON_USEDEP}]
#		>=dev-python/pytest-xdist-1.2.28[${PYTHON_USEDEP}]
#		~dev-python/coverage-4.5.3[${PYTHON_USEDEP}]
#		~dev-python/codecov-2.0.15[${PYTHON_USEDEP}]
#		~dev-python/pytest-cov-2.7.1[${PYTHON_USEDEP}]
#		>=dev-python/trustme-0.4.0[${PYTHON_USEDEP}]
#		dev-python/pyopenssl[${PYTHON_USEDEP}]
#		dev-python/requests-unixsocket[${PYTHON_USEDEP}]
#	)"

#python_test() {
#	py.test -v || die "tests failed under ${EPYTHON}"
#}
