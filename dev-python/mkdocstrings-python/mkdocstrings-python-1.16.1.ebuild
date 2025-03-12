# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYTHON_COMPAT=( python3_{10..13} )

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
	>=dev-python/griffe-0.49[${PYTHON_USEDEP}]
	>=dev-python/mkdocstrings-0.28[${PYTHON_USEDEP}]
	>=dev-python/mkdocs-autorefs-1.2[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/typing-extensions-4.0[${PYTHON_USEDEP}]
	' 3.10)
"
BDEPEND="
	test? (
		>=dev-python/beautifulsoup4-4.12.3[${PYTHON_USEDEP}]
		>=dev-python/inline-snapshot-0.18[${PYTHON_USEDEP}]
		dev-python/mkdocs-material[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

export PDM_BUILD_SCM_VERSION=${PV}

python_test() {
	local EPYTEST_DESELECT=(
		# "None" meaning particular formatter not installed
		"tests/test_rendering.py::test_format_code[None-print('Hello')]"
		"tests/test_rendering.py::test_format_code[None-aaaaa(bbbbb, ccccc=1) + ddddd.eeeee[ffff] or {ggggg: hhhhh, iiiii: jjjjj}]"
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p inline_snapshot
}
