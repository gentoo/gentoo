# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="Cheroot is the high-performance, pure-Python HTTP server used by CherryPy."
HOMEPAGE="https://cherrypy.org/
	https://pypi.org/project/cheroot/
	https://github.com/cherrypy/cheroot/"
SRC_URI="mirror://pypi/C/${PN/c/C}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ia64 ppc ~ppc64 x86"

RDEPEND="
	>=dev-python/six-1.11.0[${PYTHON_USEDEP}]
	>=dev-python/more-itertools-2.6[${PYTHON_USEDEP}]
	dev-python/jaraco-functools[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
		dev-python/jaraco-context[${PYTHON_USEDEP}]
		dev-python/jaraco-text[${PYTHON_USEDEP}]
		dev-python/portend[${PYTHON_USEDEP}]
		dev-python/pytest-forked[${PYTHON_USEDEP}]
		>=dev-python/pytest-mock-1.11.0[${PYTHON_USEDEP}]
		dev-python/pyopenssl[${PYTHON_USEDEP}]
		dev-python/requests-toolbelt[${PYTHON_USEDEP}]
		dev-python/requests-unixsocket[${PYTHON_USEDEP}]
		dev-python/trustme[${PYTHON_USEDEP}]
		dev-python/urllib3[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	sed -e "s/use_scm_version=True/version='${PV}'/" -i setup.py || die
	sed -e '/setuptools_scm/d' -i setup.cfg || die
	sed -e '/--cov/d' \
		-e '/--testmon/d' \
		-e '/--numproc/d' \
		-i pytest.ini || die

	# broken
	sed -e '/False.*localhost/d' \
		-i cheroot/test/test_ssl.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	cd "${BUILD_DIR}" || die
	pytest -vv || die "Tests failed with ${EPYTHON}"
}
