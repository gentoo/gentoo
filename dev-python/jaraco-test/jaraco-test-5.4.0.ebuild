# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN=${PN/-/.}
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Testing support by jaraco"
HOMEPAGE="
	https://github.com/jaraco/jaraco.test/
	https://pypi.org/project/jaraco.test/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/jaraco-collections[${PYTHON_USEDEP}]
	dev-python/jaraco-context[${PYTHON_USEDEP}]
	dev-python/jaraco-functools[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_test() {
	# workaround namespaces blocking test.support import (sigh!)
	mv jaraco/test jaraco_test || die
	rmdir jaraco || die
	distutils-r1_src_test
}

python_test() {
	# while technically these tests are skipped when Internet is
	# not available (they test whether auto-skipping works), we don't
	# want any Internet access whenever possible
	local EPYTEST_DESELECT=(
		tests/test_http.py::test_needs_internet
	)
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -m "not network"
}
