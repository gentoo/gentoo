# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1 optfeature

DESCRIPTION="Lightning-fast ASGI server implementation"
HOMEPAGE="https://www.uvicorn.org/"
SRC_URI="https://github.com/encode/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/asgiref-3.4.0[${PYTHON_USEDEP}]
	>=dev-python/click-7.0[${PYTHON_USEDEP}]
	>=dev-python/h11-0.8[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/cryptography[${PYTHON_USEDEP}]
		dev-python/httpx[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/python-dotenv[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/trustme[${PYTHON_USEDEP}]
		>=dev-python/websockets-10.0[${PYTHON_USEDEP}]
		dev-python/wsproto[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# too long path for unix socket
		tests/test_config.py::test_bind_unix_socket_works_with_reload_or_workers
		# need unpackaged httptools
		"tests/middleware/test_logging.py::test_trace_logging_on_http_protocol[httptools]"
		tests/protocols/test_http.py::test_fragmentation
	)

	local EPYTEST_IGNORE=()
	# love from Rust world
	if ! has_version "dev-python/watchfiles[${PYTHON_USEDEP}]"; then
		EPYTEST_IGNORE+=(
			tests/supervisors/test_reload.py
		)
	fi

	epytest
}

pkg_postinst() {
	optfeature "auto reload on file changes" dev-python/watchfiles
}
