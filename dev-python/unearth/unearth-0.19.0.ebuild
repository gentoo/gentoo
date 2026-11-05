# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYPI_VERIFY_REPO=https://github.com/frostming/unearth
PYTHON_COMPAT=( python3_{12..15} )

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
	<dev-python/httpx2-3[${PYTHON_USEDEP}]
	>=dev-python/httpx2-2.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/flask[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/requests-wsgi-adapter[${PYTHON_USEDEP}]
		dev-python/trustme[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-{httpserver,mock} )
distutils_enable_tests pytest
