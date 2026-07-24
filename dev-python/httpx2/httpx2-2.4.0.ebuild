# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

# This package combines httpx2 and httpcore2 (because of exact version pin).
DESCRIPTION="The next generation HTTP client (Pydantic fork)"
HOMEPAGE="
	https://pypi.org/project/httpx2/
	https://pypi.org/project/httpcore2/
	https://github.com/pydantic/httpx2/
"
SRC_URI="
	https://github.com/pydantic/httpx2/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 ppc x86"
IUSE="cli"

RDEPEND="
	dev-python/anyio[${PYTHON_USEDEP}]
	>=dev-python/idna-3.18[${PYTHON_USEDEP}]
	>=dev-python/h11-0.16[${PYTHON_USEDEP}]
	>=dev-python/truststore-0.10[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/typing-extensions-4.5.0[${PYTHON_USEDEP}]
	' 3.12)
	cli? (
		=dev-python/click-8*[${PYTHON_USEDEP}]
		=dev-python/pygments-2*[${PYTHON_USEDEP}]
		>=dev-python/rich-10[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	dev-python/hatch-fancy-pypi-readme[${PYTHON_USEDEP}]
	dev-python/uv-dynamic-versioning[${PYTHON_USEDEP}]
	test? (
		dev-python/brotlicffi[${PYTHON_USEDEP}]
		dev-python/chardet[${PYTHON_USEDEP}]
		dev-python/cryptography[${PYTHON_USEDEP}]
		dev-python/h2[${PYTHON_USEDEP}]
		dev-python/socksio[${PYTHON_USEDEP}]
		dev-python/trio[${PYTHON_USEDEP}]
		dev-python/trustme[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
		dev-python/uvicorn[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			>=dev-python/zstandard-0.18.0[${PYTHON_USEDEP}]
		' 3.12 3.13)
	)
"

EPYTEST_PLUGINS=( anyio pytest-{httpbin,trio} )
EPYTEST_XDIST=1
distutils_enable_tests pytest

python_compile() {
	local -x UV_DYNAMIC_VERSIONING_BYPASS=${PV}

	cd src/httpcore2 || die
	distutils-r1_python_compile
	cd ../httpx2 || die
	distutils-r1_python_compile
	cd ../.. || die
}

python_test() {
	local EPYTEST_DESELECT=(
		# random HTTP header case mismatch
		tests/httpx2/test_main.py::test_auth
		tests/httpx2/test_main.py::test_binary
		tests/httpx2/test_main.py::test_follow_redirects
		tests/httpx2/test_main.py::test_get
		tests/httpx2/test_main.py::test_json
		tests/httpx2/test_main.py::test_post
		tests/httpx2/test_main.py::test_redirects
		tests/httpx2/test_main.py::test_verbose
		# Internet
		tests/httpcore2/test_cancellations.py::test_h2_timeout_during_request
		tests/httpx2/client/test_proxies.py::test_async_proxy_close
		tests/httpx2/client/test_proxies.py::test_sync_proxy_close
	)

	local EPYTEST_IGNORE=()
	if ! use cli; then
		EPYTEST_IGNORE+=(
			tests/httpx2/test_main.py
		)
	fi

	epytest tests/{httpcore2,httpx2}
}
