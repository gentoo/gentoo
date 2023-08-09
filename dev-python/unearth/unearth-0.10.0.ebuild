# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="A utility to fetch and download python packages"
HOMEPAGE="
	https://pypi.org/project/unearth/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-httpserver[${PYTHON_USEDEP}]
		dev-python/flask[${PYTHON_USEDEP}]
		dev-python/requests-wsgi-adapter[${PYTHON_USEDEP}]
		dev-python/trustme[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
