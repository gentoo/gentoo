# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_VERIFY_REPO=https://github.com/karpetrosyan/httpx-aiohttp
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Aiohttp transport for HTTPX"
HOMEPAGE="
	https://github.com/karpetrosyan/httpx-aiohttp
	https://pypi.org/project/httpx-aiohttp/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
ROPERTIES="test_network"
RESTRICT="test"

RDEPEND="
	>=dev-python/aiohttp-3.10.0[${PYTHON_USEDEP}]
	<dev-python/aiohttp-4[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.27.0[${PYTHON_USEDEP}]
"

BDEPEND="
	dev-python/hatch-fancy-pypi-readme[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( anyio pytest-asyncio trio )
EPYTEST_IGNORE=(
	scripts/httpx_test.py
)
distutils_enable_tests pytest
