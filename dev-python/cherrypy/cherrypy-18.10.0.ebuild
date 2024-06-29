# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_PN="CherryPy"
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="CherryPy is a pythonic, object-oriented HTTP framework"
HOMEPAGE="
	https://cherrypy.dev/
	https://github.com/cherrypy/cherrypy/
	https://pypi.org/project/CherryPy/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv ~sparc x86"
IUSE="ssl test"

RDEPEND="
	>=dev-python/cheroot-8.2.1[${PYTHON_USEDEP}]
	>=dev-python/portend-2.1.1[${PYTHON_USEDEP}]
	dev-python/more-itertools[${PYTHON_USEDEP}]
	dev-python/zc-lockfile[${PYTHON_USEDEP}]
	dev-python/jaraco-collections[${PYTHON_USEDEP}]
	ssl? (
		dev-python/pyopenssl[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/routes[${PYTHON_USEDEP}]
		dev-python/simplejson[${PYTHON_USEDEP}]
		dev-python/objgraph[${PYTHON_USEDEP}]
		dev-python/path[${PYTHON_USEDEP}]
		dev-python/requests-toolbelt[${PYTHON_USEDEP}]
		dev-python/pytest-services[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	sed -i -e '/cov/d' pytest.ini || die
	# upstream has been using xfail to mark flaky tests, then added
	# xfail_strict... not a good idea
	sed -i -e '/xfail_strict/d' pytest.ini || die

	distutils-r1_python_prepare_all
}

python_test() {
	local EPYTEST_DESELECT=()
	[[ ${EPYTHON} == python3.11 ]] && EPYTEST_DESELECT+=(
		# broken by changes in traceback output
		cherrypy/test/test_request_obj.py::RequestObjectTests::testErrorHandling
		cherrypy/test/test_tools.py::ToolTests::testHookErrors
	)

	epytest
}
