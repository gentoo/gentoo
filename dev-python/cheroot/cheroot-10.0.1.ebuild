# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="High-performance, pure-Python HTTP server used by CherryPy"
HOMEPAGE="
	https://cherrypy.dev/
	https://pypi.org/project/cheroot/
	https://github.com/cherrypy/cheroot/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ppc ppc64 ~riscv ~sparc x86"
IUSE="test-rust"

RDEPEND="
	>=dev-python/more-itertools-2.6[${PYTHON_USEDEP}]
	dev-python/jaraco-functools[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools-scm-7.0.0[${PYTHON_USEDEP}]
	test? (
		dev-python/jaraco-context[${PYTHON_USEDEP}]
		dev-python/jaraco-text[${PYTHON_USEDEP}]
		dev-python/portend[${PYTHON_USEDEP}]
		dev-python/pytest-forked[${PYTHON_USEDEP}]
		>=dev-python/pytest-mock-1.11.0[${PYTHON_USEDEP}]
		dev-python/requests-toolbelt[${PYTHON_USEDEP}]
		dev-python/requests-unixsocket[${PYTHON_USEDEP}]
		dev-python/urllib3[${PYTHON_USEDEP}]
		test-rust? (
			dev-python/pyopenssl[${PYTHON_USEDEP}]
			dev-python/trustme[${PYTHON_USEDEP}]
		)
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

python_prepare_all() {
	sed -e '/--cov/d' \
		-e '/--testmon/d' \
		-e '/--numproc/d' \
		-i pytest.ini || die

	# broken
	sed -i -e '/False.*localhost/d' cheroot/test/test_ssl.py || die
	# pypytools is py2 stuff
	sed -i -e '/pypytools/d' cheroot/test/test_server.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	local EPYTEST_DESELECT=(
		# requires pypytools, see above
		cheroot/test/test_server.py::test_high_number_of_file_descriptors
		# known test failures with OpenSSL 3.2.0
		cheroot/test/test_ssl.py::test_https_over_http_error
	)

	case ${EPYTHON} in
		pypy3)
			EPYTEST_DESELECT+=(
				# https://github.com/cherrypy/cheroot/issues/695
				cheroot/test/test_conn.py::test_remains_alive_post_unhandled_exception
			)
			;;
	esac

	local EPYTEST_IGNORE=()
	if ! has_version "dev-python/pyopenssl[${PYTHON_USEDEP}]" ||
		! has_version "dev-python/trustme[${PYTHON_USEDEP}]"
	then
		EPYTEST_IGNORE+=(
			cheroot/test/test_ssl.py
		)
	fi

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p pytest_mock
}
