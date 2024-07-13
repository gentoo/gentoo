# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1

DESCRIPTION="A fake file system that mocks the Python file system modules"
HOMEPAGE="
	https://github.com/pytest-dev/pyfakefs/
	https://pypi.org/project/pyfakefs/
"
SRC_URI="
	https://github.com/pytest-dev/pyfakefs/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=()
	local EPYTEST_IGNORE=(
		# test for regression with opentimelineio package
		pyfakefs/pytest_tests/segfault_test.py
		# test for regression with undefined package
		pyfakefs/pytest_tests/pytest_fixture_test.py
	)

	if ! has_version "dev-python/pandas[${PYTHON_USEDEP}]"; then
		EPYTEST_IGNORE+=(
			pyfakefs/pytest_tests/pytest_reload_pandas_test.py
		)
	fi

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p pyfakefs.pytest_plugin
}
