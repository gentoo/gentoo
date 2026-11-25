# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Convert WSGI app to ASGI app or ASGI app to WSGI app"
HOMEPAGE="
	https://github.com/abersheeran/a2wsgi/
	https://pypi.org/project/a2wsgi/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

BDEPEND="
	test? (
		<dev-python/httpx-1[${PYTHON_USEDEP}]
		>=dev-python/httpx-0.22.0[${PYTHON_USEDEP}]
		dev-python/starlette[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-asyncio )
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# requires baize
	tests/test_asgi.py::test_baize_stream_response
)
