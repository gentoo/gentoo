# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 pypi

DESCRIPTION="A plugin that allows the export of locked packages to various formats"
HOMEPAGE="
	https://python-poetry.org/
	https://github.com/python-poetry/poetry-plugin-export
	https://pypi.org/project/poetry-plugin-export/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/poetry-core-1.8.0[${PYTHON_USEDEP}]
"

DEPEND="
	test? (
		dev-python/poetry[${PYTHON_USEDEP}]
		>=dev-python/pytest-mock-3.9[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-3.1[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
