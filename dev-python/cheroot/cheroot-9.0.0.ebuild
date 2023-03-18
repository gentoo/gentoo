# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="High-performance, pure-Python HTTP server used by CherryPy"
HOMEPAGE="
	https://cherrypy.dev/
	https://pypi.org/project/cheroot/
	https://github.com/cherrypy/cheroot/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv ~sparc x86"
IUSE="test-rust"

RDEPEND="
	>=dev-python/six-1.11.0[${PYTHON_USEDEP}]
	>=dev-python/more-itertools-2.6[${PYTHON_USEDEP}]
	dev-python/jaraco-functools[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
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
	)

	local EPYTEST_IGNORE=()
	if ! has_version "dev-python/pyopenssl[${PYTHON_USEDEP}]" ||
		! has_version "dev-python/trustme[${PYTHON_USEDEP}]"
	then
		EPYTEST_IGNORE+=(
			cheroot/test/test_ssl.py
		)
	fi

	epytest -p no:flaky
}
