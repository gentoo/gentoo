# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_VERIFY_REPO=https://github.com/karpetrosyan/httpx-aiohttp
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Aiohttp transport for HTTPX"
HOMEPAGE="
	https://github.com/karpetrosyan/httpx-aiohttp
	https://pypi.org/project/httpx-aiohttp/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="
	>=dev-python/aiohttp-3.10.0[${PYTHON_USEDEP}]
	<dev-python/aiohttp-4[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.27.0[${PYTHON_USEDEP}]
"

BDEPEND="
	dev-python/hatch-fancy-pypi-readme[${PYTHON_USEDEP}]
	test? (
		>=dev-python/httpx2-2[${PYTHON_USEDEP}]
		<dev-python/httpx2-3[${PYTHON_USEDEP}]
	)
"

# tests/httpx is a git submodule (a fork of the httpx test suite) that is not
# part of the sdist. Upstream's own scripts/test only runs tests/local, which
# is shipped.
EPYTEST_PLUGINS=( anyio pytest-asyncio )
EPYTEST_DESELECT=(
	# Requires network access to httpbin.org
	tests/local/test_aiohttp_client.py::test_response_is_closed_after_request
)
distutils_enable_tests pytest

python_test() {
	epytest tests/local
}
