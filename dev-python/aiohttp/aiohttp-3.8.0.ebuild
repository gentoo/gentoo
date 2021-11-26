# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} pypy3 )

inherit distutils-r1 multiprocessing

DESCRIPTION="http client/server for asyncio"
HOMEPAGE="
	https://pypi.org/project/aiohttp/
	https://github.com/aio-libs/aiohttp/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~sparc ~x86"

RDEPEND="
	app-arch/brotli[python,${PYTHON_USEDEP}]
	>=dev-python/aiosignal-1.1.2[${PYTHON_USEDEP}]
	>=dev-python/async_timeout-4.0.0_alpha3[${PYTHON_USEDEP}]
	>=dev-python/attrs-17.3.0[${PYTHON_USEDEP}]
	>=dev-python/charset_normalizer-2.0[${PYTHON_USEDEP}]
	>=dev-python/frozenlist-1.1.1[${PYTHON_USEDEP}]
	>=dev-python/multidict-4.5.0[${PYTHON_USEDEP}]
	>=dev-python/yarl-1.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		app-arch/brotli[python,${PYTHON_USEDEP}]
		dev-python/async_generator[${PYTHON_USEDEP}]
		dev-python/freezegun[${PYTHON_USEDEP}]
		www-servers/gunicorn[${PYTHON_USEDEP}]
		dev-python/pytest-forked[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/re-assert[${PYTHON_USEDEP}]
		dev-python/trustme[${PYTHON_USEDEP}]
	)
"

DOCS=( CHANGES.rst CONTRIBUTORS.txt README.rst )

distutils_enable_tests pytest
distutils_enable_sphinx docs \
	'>=dev-python/alabaster-0.6.2' \
	'dev-python/sphinxcontrib-asyncio' \
	'dev-python/sphinxcontrib-blockdiag' \
	'dev-python/sphinxcontrib-newsfeed' \
	'dev-python/sphinxcontrib-spelling' \
	'dev-python/sphinx' \
	'dev-python/sphinx-aiohttp-theme'

# TODO: re-cythonize modules?

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/${P}-examples.patch
	)

	# increate a little the timeout
	sed -e '/abs_tol=/s/0.001/0.01/' -i tests/test_helpers.py || die

	# xfail_strict fails on py3.10
	sed -i -e '/--cov/d' -e '/xfail_strict/d' setup.cfg || die
	distutils-r1_src_prepare
}

python_test() {
	local EPYTEST_IGNORE=(
		# proxy is not packaged
		tests/test_proxy_functional.py
	)

	local EPYTEST_DESELECT=(
		# runtime warnings
		'tests/test_client_functional.py::test_aiohttp_request_coroutine[pyloop]'
		# Internet
		tests/test_client_session.py::test_client_session_timeout_zero
	)

	[[ ${EPYTHON} == pypy3 ]] && EPYTEST_DESELECT+=(
		# C extensions are not used on PyPy3
		tests/test_http_parser.py::test_c_parser_loaded
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=pytest_mock,xdist.plugin,pytest_forked
	mv aiohttp aiohttp.hidden || die
	epytest -n "$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")" --forked
	mv aiohttp.hidden aiohttp || die
}
