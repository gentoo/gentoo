# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="pytest plugin to check whether Python modules can be imported"
HOMEPAGE="
	https://github.com/projg2/pytest-import-check/
	https://pypi.org/project/pytest-import-check/
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ~ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	>=dev-python/pytest-8.1[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/setuptools[${PYTHON_USEDEP}]
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=pytest_import_check.plugin
	epytest
}
