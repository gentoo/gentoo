# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Run tests in isolated forked subprocesses"
HOMEPAGE="
	https://pypi.org/project/pytest-forked/
	https://github.com/pytest-dev/pytest-forked/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

# Please do not RDEPEND on pytest; this package won't do anything
# without pytest installed, and there is no reason to force older
# implementations on pytest.
RDEPEND="
	dev-python/py[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	local PATCHES=(
		# https://github.com/pytest-dev/pytest-forked/pull/90
		"${FILESDIR}/${P}-pytest-8.patch"
	)

	distutils-r1_src_prepare

	# this is not printed when loaded via PYTEST_PLUGINS
	sed -i -e '/loaded_pytest_plugins/d' testing/test_xfail_behavior.py || die
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=pytest_forked
	epytest -o tmp_path_retention_count=1
}
