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

# Tests are disabled as it requires to fetch parent httpx project as submodule.
RESTRICT="test"

RDEPEND="
	>=dev-python/aiohttp-3.10.0[${PYTHON_USEDEP}]
	<dev-python/aiohttp-4[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.27.0[${PYTHON_USEDEP}]
"

BDEPEND="
	dev-python/hatch-fancy-pypi-readme[${PYTHON_USEDEP}]
"

# Here previous work about test kept in case it can help for bootstrap.
# RESTRICT="!test? ( test )"
# Also appending the test dependencies used in httpx.
# BDEPEND+="
# 	test? (
# 		dev-python/anyio[${PYTHON_USEDEP}]
# 		dev-python/brotlicffi[${PYTHON_USEDEP}]
# 		dev-python/chardet[${PYTHON_USEDEP}]
# 		dev-python/cryptography[${PYTHON_USEDEP}]
# 		dev-python/h2[${PYTHON_USEDEP}]
# 		dev-python/pytest[${PYTHON_USEDEP}]
# 		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
# 		dev-python/socksio[${PYTHON_USEDEP}]
# 		dev-python/trustme[${PYTHON_USEDEP}]
# 		dev-python/typing-extensions[${PYTHON_USEDEP}]
# 		dev-python/uvicorn[${PYTHON_USEDEP}]
# 		>=dev-python/zstandard-0.18.0[${PYTHON_USEDEP}]
# 		$(python_gen_cond_dep '
# 			dev-python/trio[${PYTHON_USEDEP}]
# 		' 3.{12..14})
# 	)
# "
#
# EPYTEST_PLUGINS=( anyio pytest-asyncio trio )
# EPYTEST_IGNORE=(
# 	scripts/httpx_test.py
# )
# distutils_enable_tests pytest
