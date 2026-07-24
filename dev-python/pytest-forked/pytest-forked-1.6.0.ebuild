# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Run tests in isolated forked subprocesses"
HOMEPAGE="
	https://pypi.org/project/pytest-forked/
	https://github.com/pytest-dev/pytest-forked/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

# Please do not RDEPEND on pytest; this package won't do anything
# without pytest installed, and there is no reason to force older
# implementations on pytest.
RDEPEND="
	dev-python/py[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( ${PN} )
EPYTEST_PLUGIN_LOAD_VIA_ENV=1
distutils_enable_tests pytest

PATCHES=(
	# backports from master branch
	"${FILESDIR}/${P}-pytest-8.patch"
	"${FILESDIR}/${P}-pytest-9.patch"
)

python_prepare_all() {
	distutils-r1_python_prepare_all

	# this is not printed when loaded via PYTEST_PLUGINS
	sed -e '/loaded_pytest_plugins/d' -i testing/test_xfail_behavior.py || die
}

python_test() {
	local -x COLUMNS=80 # tests check output bug #754165
	epytest -o tmp_path_retention_count=1
}
