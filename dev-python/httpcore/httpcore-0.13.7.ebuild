# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="A minimal low-level HTTP client"
HOMEPAGE="https://www.encode.io/httpcore/"
SRC_URI="https://github.com/encode/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 sparc ~x86"

RDEPEND="
	=dev-python/anyio-3*[${PYTHON_USEDEP}]
	<dev-python/h11-0.13[${PYTHON_USEDEP}]
	<dev-python/h2-5[${PYTHON_USEDEP}]
	=dev-python/sniffio-1*[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/trustme[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	# trio is not in the tree, anyio is causing tons of test failures
	# (probably insisting on using trio)
	sed -i 's/^@pytest.mark.\(anyio\|trio\)/@pytest.mark.skip/' \
		tests/async_tests/test_*.py || die
	sed -i '/^import trio/d' tests/utils.py || die
	# pproxy is not in the tree, the associated fixture
	# must be disabled to prevent errors during test setup
	sed -i 's/def proxy_server().*/&\n    pytest.skip()/' \
		tests/conftest.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	local skipped_tests=(
		# Require Internet access or hypercorn (not in the tree)
		tests/test_threadsafety.py::test_threadsafe_basic
		tests/sync_tests/test_interfaces.py::test_http_request
		tests/sync_tests/test_interfaces.py::test_https_request
		tests/sync_tests/test_interfaces.py::test_http2_request
		tests/sync_tests/test_interfaces.py::test_closing_http_request
		tests/sync_tests/test_interfaces.py::test_connection_pool_get_connection_info
		tests/sync_tests/test_interfaces.py::test_max_keepalive_connections_handled_correctly
		tests/sync_tests/test_interfaces.py::test_explicit_backend_name
		tests/sync_tests/test_interfaces.py::test_connection_timeout_tcp
		tests/sync_tests/test_interfaces.py::test_broken_socket_detection_many_open_files
		tests/sync_tests/test_retries.py::test_no_retries
		tests/sync_tests/test_retries.py::test_retries_exceeded
		tests/sync_tests/test_retries.py::test_retries_enabled
		# Require hypercorn
		tests/sync_tests/test_interfaces.py::test_connection_timeout_uds
	)
	epytest ${skipped_tests[@]/#/--deselect }
}
