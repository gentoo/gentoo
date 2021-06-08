# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} pypy3 )
inherit distutils-r1

DESCRIPTION="Thin-wrapper around the mock package for easier use with pytest"
HOMEPAGE="https://github.com/pytest-dev/pytest-mock/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86 ~x64-macos"

RDEPEND=">=dev-python/pytest-5[${PYTHON_USEDEP}]"
BDEPEND="dev-python/setuptools_scm[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

python_test() {
	local deselect=()
	if has_version dev-python/mock; then
		deselect+=(
			tests/test_pytest_mock.py::test_standalone_mock
		)
	fi

	distutils_install_for_testing
	epytest --assert=plain ${deselect[@]/#/--deselect }
}
