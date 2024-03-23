# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Plugin for pytest that automatically reruns flaky tests"
HOMEPAGE="
	https://github.com/box/flaky/
	https://pypi.org/project/flaky/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

# https://github.com/box/flaky/issues/198
RDEPEND="
	<dev-python/pytest-8.1[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/genty[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

src_prepare() {
	# (removed upstream)
	rm flaky/flaky_nose_plugin.py || die
	sed -i -e '/flaky_nose_plugin/d' setup.py || die
	distutils-r1_src_prepare
}

python_test() {
	epytest -k 'example and not options' --doctest-modules test/test_pytest/ || die
	epytest -p no:flaky test/test_pytest/test_flaky_pytest_plugin.py || die
	epytest --force-flaky --max-runs 2 test/test_pytest/test_pytest_options_example.py || die
}
