# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_PN="CherryPy"
PYTHON_COMPAT=( python3_{10..13} pypy3 pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="CherryPy is a pythonic, object-oriented HTTP framework"
HOMEPAGE="
	https://cherrypy.dev/
	https://github.com/cherrypy/cherrypy/
	https://pypi.org/project/CherryPy/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
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
		!sparc? (
			net-misc/memcached
			dev-python/pylibmc[${PYTHON_USEDEP}]
			dev-python/pytest-services[${PYTHON_USEDEP}]
		)
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
	local opts=()

	# These tests are gracefully skipped when pylibmc is missing but not
	# if pytest-services is missing -- even though that's the only test
	# using these fixtures.
	if ! has_version "dev-python/pytest-services[${PYTHON_USEDEP}]"; then
		EPYTEST_DESELECT+=(
			cherrypy/test/test_session.py::MemcachedSessionTest
		)
	else
		opts+=( -p pytest-services )
	fi

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest "${opts[@]}"
}
