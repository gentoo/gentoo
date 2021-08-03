# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} pypy3 )

inherit distutils-r1 multiprocessing

DESCRIPTION="http client/server for asyncio"
HOMEPAGE="https://pypi.org/project/aiohttp/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv sparc x86"

RDEPEND="
	>=dev-python/async_timeout-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/attrs-17.3.0[${PYTHON_USEDEP}]
	dev-python/chardet[${PYTHON_USEDEP}]
	>=dev-python/multidict-4.5.0[${PYTHON_USEDEP}]
	>=dev-python/yarl-1.0[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		!!dev-python/pytest-aiohttp
		app-arch/brotli[python,${PYTHON_USEDEP}]
		dev-python/async_generator[${PYTHON_USEDEP}]
		dev-python/freezegun[${PYTHON_USEDEP}]
		www-servers/gunicorn[${PYTHON_USEDEP}]
		dev-python/pytest-forked[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/re-assert[${PYTHON_USEDEP}]
		dev-python/trustme[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/aiohttp-3.7.4-brotli.patch
	"${FILESDIR}"/aiohttp-3.7.4-fix-py3.10.patch
)

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

python_prepare_all() {
	# newer chardet works too
	sed -e 's|chardet>=2.0,<4.0|chardet>=2.0|' \
		-i setup.py aiohttp.egg-info/requires.txt || die

	# takes a very long time, then fails
	rm tests/test_pytest_plugin.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	local deselect=(
		# fails with a 'runtime warning'
		'tests/test_client_functional.py::test_aiohttp_request_coroutine[pyloop]'

		# fragile to test paths
		tests/test_route_def.py::test_static

		# requires Internet
		tests/test_formdata.py::test_mark_formdata_as_processed

		# 'Event loop is closed' -- probably broken by old age
		'tests/test_streams.py::TestDataQueue::test_read[pyloop]'
		'tests/test_streams.py::TestDataQueue::test_read_eof[pyloop]'
		'tests/test_streams.py::TestDataQueue::test_read_cancelled[pyloop]'
		'tests/test_streams.py::TestDataQueue::test_read_until_eof[pyloop]'
		'tests/test_streams.py::TestDataQueue::test_read_exc[pyloop]'
		'tests/test_streams.py::TestDataQueue::test_read_exception[pyloop]'
		'tests/test_streams.py::TestDataQueue::test_read_exception_with_data[pyloop]'
		'tests/test_streams.py::TestDataQueue::test_read_exception_on_wait[pyloop]'
		'tests/test_streams.py::TestDataQueue::test_exception_waiter[pyloop]'
	)

	[[ ${EPYTHON} == pypy3 ]] && deselect+=(
		# fails with a 'runtime warning'
		tests/test_multipart.py::TestPartReader::test_read_boundary_with_incomplete_chunk
	)

	pushd "${BUILD_DIR}/lib" >/dev/null || die
	ln -snf "${S}"/{LICENSE.txt,tests} . || die
	epytest -n "$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")" --forked \
		${deselect[@]/#/--deselect } tests
	rm -rf .hypothesis .pytest_cache tests || die
	popd >/dev/null || die
}
