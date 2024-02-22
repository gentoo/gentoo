# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Send responses to HTTPX using pytest"
HOMEPAGE="
	https://colin-b.github.io/pytest_httpx/
	https://github.com/Colin-b/pytest_httpx/
	https://pypi.org/project/pytest-httpx/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	=dev-python/httpx-0.27*[${PYTHON_USEDEP}]
	<dev-python/pytest-9[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
