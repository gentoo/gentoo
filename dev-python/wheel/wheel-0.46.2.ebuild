# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 8 -- sys-apps/portage dep
EAPI=8

DISTUTILS_USE_PEP517=flit
PYPI_VERIFY_REPO=https://github.com/pypa/wheel
PYTHON_COMPAT=( python3_{11..14} python3_{13,14}t pypy3_11 )

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
	dev-python/packaging[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/setuptools[${PYTHON_USEDEP}]
	)
"

# xdist is slightly flaky here
EPYTEST_PLUGINS=( pytest-rerunfailures )
EPYTEST_RERUNS=5
EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# fails if any setuptools plugin imported the module first
		tests/test_bdist_wheel.py::test_deprecated_import
	)

	epytest
}
