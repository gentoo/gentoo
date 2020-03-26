# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="Cheroot is the high-performance, pure-Python HTTP server used by CherryPy."
HOMEPAGE="https://cherrypy.org/ https://pypi.org/project/Cheroot/ https://github.com/cherrypy/cheroot"
SRC_URI="mirror://pypi/C/${PN/c/C}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~x86"
# Unit tests are temporarily disabled for this version, see below for
# what needs to be done.
#IUSE="test"
RESTRICT="test"

RDEPEND="
	>=dev-python/six-1.11.0[${PYTHON_USEDEP}]
	>=dev-python/more-itertools-2.6[${PYTHON_USEDEP}]
	dev-python/jaraco-functools[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}
	test? (
		>=dev-python/pytest-mock-1.11.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-1.2.28[${PYTHON_USEDEP}]
		dev-python/pyopenssl[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	distutils-r1_python_prepare_all

	sed -e "s/use_scm_version=True/version='${PV}'/" -i setup.py || die
	sed -e '/setuptools_scm/d' -i setup.cfg || die
}
