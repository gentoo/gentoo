# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Plugin for pytest that automatically reruns flaky tests"
HOMEPAGE="
	https://github.com/box/flaky/
	https://pypi.org/project/flaky/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		dev-python/genty[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

src_prepare() {
	rm flaky/flaky_nose_plugin.py || die
	sed -i -e '/flaky_nose_plugin/d' setup.py || die
	distutils-r1_src_prepare
}

python_test() {
	epytest -k 'example and not options' --doctest-modules test/test_pytest/ || die
	epytest -p no:flaky test/test_pytest/test_flaky_pytest_plugin.py || die
	epytest --force-flaky --max-runs 2 test/test_pytest/test_pytest_options_example.py || die
}
