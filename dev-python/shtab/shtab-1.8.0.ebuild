# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/iterative/shtab
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Automagic shell tab completion for Python CLI applications"
HOMEPAGE="
	https://github.com/iterative/shtab/
	https://pypi.org/project/shtab/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	# Disable pytest-cov
	epytest -o addopts=
}
