# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Plugin for pytest that automatically reruns flaky tests"
HOMEPAGE="
	https://github.com/box/flaky/
	https://pypi.org/project/flaky/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/genty[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	# this one needs to be run without the plugin
	epytest test/test_pytest/test_flaky_pytest_plugin.py || die

	local EPYTEST_PLUGINS=( flaky )
	epytest -k 'example and not options' --doctest-modules test/test_pytest/ || die
	epytest --force-flaky --max-runs 2 test/test_pytest/test_pytest_options_example.py || die
}
