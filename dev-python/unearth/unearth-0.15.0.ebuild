# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="A utility to fetch and download python packages"
HOMEPAGE="
	https://pypi.org/project/unearth/
	https://github.com/frostming/unearth/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	<dev-python/httpx-1[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.27.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/flask[${PYTHON_USEDEP}]
		dev-python/pytest-httpserver[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/requests-wsgi-adapter[${PYTHON_USEDEP}]
		dev-python/trustme[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p pytest_httpserver -p pytest_mock
}
