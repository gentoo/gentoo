# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Traceback fiddling library for Python"
HOMEPAGE="
	https://github.com/ionelmc/python-tblib/
	https://pypi.org/project/tblib/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv ~sparc x86"

BDEPEND="
	test? (
		dev-python/twisted[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	sed -i -e '/--benchmark-disable/d' pytest.ini || die
}

python_test() {
	local EPYTEST_IGNORE=(
		tests/test_perf.py
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTHONNODEBUGRANGES=yes
	epytest
}
