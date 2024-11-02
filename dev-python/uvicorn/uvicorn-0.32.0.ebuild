# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 python3_{10..13} )

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
KEYWORDS="~amd64 arm arm64 ~mips ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
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
		dev-python/httptools[${PYTHON_USEDEP}]
		dev-python/httpx[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
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

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# too long path for unix socket
		tests/test_config.py::test_bind_unix_socket_works_with_reload_or_workers
		# TODO
		'tests/protocols/test_http.py::test_close_connection_with_multiple_requests[httptools]'
	)
	case ${EPYTHON} in
		pypy3)
			# TODO
			EPYTEST_DESELECT+=(
				tests/middleware/test_logging.py::test_running_log_using_fd
			)
			;;
	esac

	epytest
}

pkg_postinst() {
	optfeature "auto reload on file changes" dev-python/watchfiles
}
