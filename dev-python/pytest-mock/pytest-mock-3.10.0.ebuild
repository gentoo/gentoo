# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Thin-wrapper around the mock package for easier use with pytest"
HOMEPAGE="
	https://github.com/pytest-dev/pytest-mock/
	https://pypi.org/project/pytest-mock/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

RDEPEND="
	>=dev-python/pytest-6[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	# obsolete, upst. e2016928db1147a2a46de6ee9fa878ca0e9d8fc8
	sed -i -e '/import py\.code/d' tests/test_pytest_mock.py || die
	distutils-r1_src_prepare
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=pytest_mock,pytest_asyncio.plugin
	local EPYTEST_DESELECT=()

	if has_version dev-python/mock; then
		EPYTEST_DESELECT+=(
			tests/test_pytest_mock.py::test_standalone_mock
		)
	fi

	epytest --assert=plain
}
