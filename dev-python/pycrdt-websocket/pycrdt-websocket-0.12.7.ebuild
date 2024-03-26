# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="WebSocket connector for pycrdt"
HOMEPAGE="https://github.com/jupyter-server/pycrdt-websocket"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-python/pycrdt-0.8.7[${PYTHON_USEDEP}]
	dev-python/aiosqlite[${PYTHON_USEDEP}]"
BDEPEND="test? (
	dev-python/uvicorn[${PYTHON_USEDEP}]
)"

# skip tests that depends on yjs not available in Gentoo
EPYTEST_DESELECT=(
	tests/test_pycrdt_yjs.py::test_pycrdt_yjs
)

distutils_enable_tests pytest
