# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Allows you to use fixtures in @pytest.mark.parametrize"
HOMEPAGE="
	https://github.com/dev-petrov/pytest-lazy-fixtures/
	https://pypi.org/project/pytest-lazy-fixtures/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	>=dev-python/pytest-7[${PYTHON_USEDEP}]
"

EPYTEST_PLUGIN_LOAD_VIA_ENV=1
EPYTEST_PLUGINS=( "${PN}" )
distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# test for pytest-deadfixtures compatibility
	tests/test_deadfixtures_support.py
)
