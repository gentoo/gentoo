# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Allows you to use fixtures in @pytest.mark.parametrize"
HOMEPAGE="
	https://github.com/dev-petrov/pytest-lazy-fixtures/
	https://pypi.org/project/pytest-lazy-fixtures/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~mips ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/pytest-7[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=pytest_lazy_fixtures.plugin
	epytest
}
