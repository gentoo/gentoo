# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Testing Against Learned Reference Data"
HOMEPAGE="
	https://github.com/nbiotcloud/test2ref
	https://pypi.org/project/test2ref/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/binaryornot[${PYTHON_USEDEP}]
"

EPYTEST_DESELECT=(
	# Whitespace differences
	'tests/test_main.py::test_caplog[False]'
	'tests/test_main.py::test_caplog[True]'
)

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	# addopts= to avoid pytest-cov
	epytest -o addopts=
}
