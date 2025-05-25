# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 optfeature

DESCRIPTION="Lightning-fast ASGI server implementation"
HOMEPAGE="
	https://www.uvicorn.org/
	https://github.com/encode/uvicorn/
	https://pypi.org/project/uvicorn/
"
# as of 0.28.0, no tests in sdist
SRC_URI="
	https://github.com/encode/uvicorn/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="test-rust"

RDEPEND="
	>=dev-python/asgiref-3.4.0[${PYTHON_USEDEP}]
	>=dev-python/click-7.0[${PYTHON_USEDEP}]
	>=dev-python/h11-0.8[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/typing-extensions-4.0[${PYTHON_USEDEP}]
	' 3.10)
"
BDEPEND="
	test? (
		dev-python/a2wsgi[${PYTHON_USEDEP}]
		dev-python/anyio[${PYTHON_USEDEP}]
		>=dev-python/httptools-0.6.3[${PYTHON_USEDEP}]
		>=dev-python/httpx-0.28[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
		dev-python/python-dotenv[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
		>=dev-python/websockets-10.4[${PYTHON_USEDEP}]
		dev-python/wsproto[${PYTHON_USEDEP}]
		test-rust? (
			dev-python/cryptography[${PYTHON_USEDEP}]
			dev-python/trustme[${PYTHON_USEDEP}]
			dev-python/watchfiles[${PYTHON_USEDEP}]
		)
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# too long path for unix socket
		tests/test_config.py::test_bind_unix_socket_works_with_reload_or_workers
		# TODO
		'tests/protocols/test_http.py::test_close_connection_with_multiple_requests[httptools]'
		'tests/protocols/test_websocket.py::test_send_binary_data_to_server_bigger_than_default_on_websockets[httptools-max=defaults sent=defaults+1]'
		'tests/protocols/test_websocket.py::test_send_binary_data_to_server_bigger_than_default_on_websockets[h11-max=defaults sent=defaults+1]'
	)
	case ${EPYTHON} in
		pypy3*)
			# TODO
			EPYTEST_DESELECT+=(
				tests/middleware/test_logging.py::test_running_log_using_fd
			)
			;;
		python3.14*)
			EPYTEST_DESELECT+=(
				# TODO
				tests/test_auto_detection.py::test_loop_auto
			)
			;;
	esac

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p anyio -p pytest_mock -p rerunfailures --reruns=5
}

pkg_postinst() {
	optfeature "auto reload on file changes" dev-python/watchfiles
}
