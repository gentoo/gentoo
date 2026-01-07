# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1 pypi

DESCRIPTION="Python handler for dev-python/mkdocstrings"
HOMEPAGE="
	https://mkdocstrings.github.io/python/
	https://github.com/mkdocstrings/python/
	https://pypi.org/project/mkdocstrings-python/
"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"

RDEPEND="
	>=dev-python/griffe-1.13[${PYTHON_USEDEP}]
	>=dev-python/mkdocstrings-0.30[${PYTHON_USEDEP}]
	>=dev-python/mkdocs-autorefs-1.4[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/beautifulsoup4-4.12.3[${PYTHON_USEDEP}]
		dev-python/mkdocs-material[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( inline-snapshot )
EPYTEST_XDIST=1
distutils_enable_tests pytest

export PDM_BUILD_SCM_VERSION=${PV}

EPYTEST_DESELECT=(
	# "None" meaning particular formatter not installed
	"tests/test_rendering.py::test_format_code[None-print('Hello')]"
	"tests/test_rendering.py::test_format_code[None-aaaaa(bbbbb, ccccc=1) + ddddd.eeeee[ffff] or {ggggg: hhhhh, iiiii: jjjjj}]"
)
