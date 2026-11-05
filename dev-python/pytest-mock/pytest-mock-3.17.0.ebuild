# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/pytest-dev/pytest-mock
PYTHON_COMPAT=( pypy3_12 python3_{12..15} python3_{14..15}t )

inherit distutils-r1 pypi

DESCRIPTION="Thin-wrapper around the mock package for easier use with pytest"
HOMEPAGE="
	https://github.com/pytest-dev/pytest-mock/
	https://pypi.org/project/pytest-mock/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

RDEPEND="
	>=dev-python/pytest-6.2.5[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( "${PN}" pytest-asyncio )
EPYTEST_PLUGIN_LOAD_VIA_ENV=1
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=()

	if has_version dev-python/mock; then
		EPYTEST_DESELECT+=(
			tests/test_pytest_mock.py::test_standalone_mock
		)
	fi

	epytest --assert=plain
}
