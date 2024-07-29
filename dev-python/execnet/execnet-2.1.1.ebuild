# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Rapid multi-Python deployment"
HOMEPAGE="
	https://codespeak.net/execnet/
	https://github.com/pytest-dev/execnet/
	https://pypi.org/project/execnet/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
"

distutils_enable_sphinx doc
distutils_enable_tests pytest

python_test() {
	# the test suite checks if bytecode writing can be disabled/enabled
	local -x PYTHONDONTWRITEBYTECODE=
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	# some tests are implicitly run against both sys.executable
	# and pypy3, which is redundant and results in pypy3 bytecode being
	# written to cpython install dirs
	epytest testing -k "not pypy3"
}
