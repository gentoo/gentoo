# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 8 -- sys-apps/portage dep
EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..13} python3_13t pypy3 pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="A built-package format for Python"
HOMEPAGE="
	https://github.com/pypa/wheel/
	https://pypi.org/project/wheel/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"

RDEPEND="
	>=dev-python/packaging-24.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/setuptools[${PYTHON_USEDEP}]
	)
"

EPYTEST_DESELECT=(
	# fails if any setuptools plugin imported the module first
	tests/test_bdist_wheel.py::test_deprecated_import
)

distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
