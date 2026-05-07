# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="A pyunit extension for dependency injection"
HOMEPAGE="
	https://launchpad.net/testscenarios/
	https://github.com/testing-cabal/testscenarios/
	https://pypi.org/project/testscenarios/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/testtools[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
	)
"

python_test() {
	"${EPYTHON}" -m testtools.run -v testscenarios.tests.test_suite ||
		die "Tests failed with ${EPYTHON}"
}
