# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

DESCRIPTION="http client/server for asyncio"
HOMEPAGE="https://pypi.org/project/aiohttp/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~sparc ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	>=dev-python/async_timeout-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/attrs-17.3.0[${PYTHON_USEDEP}]
	dev-python/chardet[${PYTHON_USEDEP}]
	>=dev-python/multidict-4.5.0[${PYTHON_USEDEP}]
	>=dev-python/yarl-1.0[${PYTHON_USEDEP}]
	dev-python/idna-ssl[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		${COMMON_DEPEND}
		!!dev-python/pytest-aiohttp
		dev-python/async_generator[${PYTHON_USEDEP}]
		dev-python/brotlipy[${PYTHON_USEDEP}]
		dev-python/freezegun[${PYTHON_USEDEP}]
		www-servers/gunicorn[${PYTHON_USEDEP}]
		>=dev-python/pytest-3.4.0[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		dev-python/re-assert[${PYTHON_USEDEP}]
		dev-python/trustme[${PYTHON_USEDEP}]
	)
"
RDEPEND="${COMMON_DEPEND}"

DOCS=( CHANGES.rst CONTRIBUTORS.txt README.rst )

distutils_enable_sphinx docs \
	'>=dev-python/alabaster-0.6.2' \
	'dev-python/sphinxcontrib-asyncio' \
	'dev-python/sphinxcontrib-blockdiag' \
	'dev-python/sphinxcontrib-newsfeed' \
	'dev-python/sphinxcontrib-spelling' \
	'dev-python/sphinx' \
	'dev-python/sphinx-aiohttp-theme'

distutils_enable_tests pytest || die "Tests fail with ${EPYTHON}"

python_prepare_all() {
	# Fails due to a warning
	sed -e 's:test_read_boundary_with_incomplete_chunk:_&:' \
		-i tests/test_multipart.py || die
	# with py3.7+
	sed -e 's:test_aiohttp_request_coroutine:_&:' \
		-i tests/test_client_functional.py || die

	# Fails due to path mismatch
	sed -e 's:test_static:_&:' \
		-i tests/test_route_def.py || die

	# Internet
	sed -e 's:test_mark_formdata_as_processed:_&:' \
		-i tests/test_formdata.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	pushd "${BUILD_DIR}/lib" >/dev/null || die
	ln -snf "${S}"/{LICENSE.txt,tests} . || die
	pytest -vv tests || die "Tests fail with ${EPYTHON}"
	rm -rf .pytest_cache tests || die
	popd >/dev/null || die
}
