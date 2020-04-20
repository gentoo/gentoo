# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="http client/server for asyncio"
HOMEPAGE="https://pypi.org/project/aiohttp/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
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
		dev-python/async_generator[${PYTHON_USEDEP}]
		dev-python/brotlipy[${PYTHON_USEDEP}]
		dev-python/freezegun[${PYTHON_USEDEP}]
		www-servers/gunicorn[${PYTHON_USEDEP}]
		>=dev-python/pytest-3.4.0[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
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
	sed -e 's|^async def test_aiohttp_request_coroutine(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_handle_keepalive_on_closed_connection(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_server_close_keepalive_connection(|@pytest.mark.xfail\n\0|' \
		-i tests/test_client_functional.py || die

	sed -e 's|^async def test_request_tracing_exception(|@pytest.mark.xfail\n\0|' \
		-i tests/test_client_session.py || die

	sed -e 's|^async def test_cleanup2(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_cleanup3(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_close(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_close_abort_closed_transports(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_close_cancels_cleanup_closed_handle(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_close_cancels_cleanup_handle(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_close_during_connect(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_close_twice(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_close_with_acquired_connection(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_connect_queued_operation_tracing(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_connect_reuseconn_tracing(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_connect_with_limit(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_connect_with_limit_and_limit_per_host(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_connect_with_limit_concurrent(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_connect_with_no_limit_and_limit_per_host(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_connect_with_no_limits(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_get(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_get_expired(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_get_expired_ssl(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_limit_per_host_property(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_limit_per_host_property_default(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_limit_property(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_limit_property_default(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_release(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_release_acquired(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_release_acquired_closed(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_release_already_closed(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_release_close_do_not_delete_existing_connections(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_release_not_started(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_release_ssl_transport(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_release_waiter_first_available(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_release_waiter_no_available(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_release_waiter_no_limit(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_release_waiter_per_host(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_release_waiter_release_first(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_release_waiter_skip_done_waiter(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_tcp_connector_dns_throttle_requests_cancelled_when_close(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_tcp_connector_do_not_raise_connector_ssl_error(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_tcp_connector_uses_provided_local_addr(|@pytest.mark.xfail\n\0|' \
		-i tests/test_connector.py || die

	sed -e 's|^    async def test_read_boundary_with_incomplete_chunk(|    @pytest.mark.xfail\n\0|' \
		-e 's|^    async def test_read_incomplete_chunk(|    @pytest.mark.xfail\n\0|' \
		-i tests/test_multipart.py || die

	sed -e 's|^def test_aiohttp_plugin_async_fixture(|@pytest.mark.xfail\n\0|' \
		-i tests/test_pytest_plugin.py || die

	sed -e 's|^async def test_mixed_middleware(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_new_style_middleware_class(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_new_style_middleware_method(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_old_style_middleware(|@pytest.mark.xfail\n\0|' \
		-e 's|^async def test_old_style_middleware_class(|@pytest.mark.xfail\n\0|' \
		-i tests/test_web_middleware.py || die

	sed -e 's|^async def test_client_disconnect(|@pytest.mark.xfail\n\0|' \
		-i tests/test_web_protocol.py || die

	sed -e 's|^async def test_partially_applied_handler(|@pytest.mark.xfail\n\0|' \
		-i tests/test_web_urldispatcher.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	pytest -vv "${S}/tests" || die "Tests fail with ${EPYTHON}"
}
