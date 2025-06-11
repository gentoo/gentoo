# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 pypi

DESCRIPTION="Extensions to the Python standard library unit testing framework"
HOMEPAGE="
	https://github.com/testing-cabal/testtools/
	https://pypi.org/project/testtools/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		>=dev-python/fixtures-2.0.0[${PYTHON_USEDEP}]
		dev-python/testscenarios[${PYTHON_USEDEP}]
		dev-python/testresources[${PYTHON_USEDEP}]
		dev-python/twisted[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-2.7.2-twisted-fix.patch"
	"${FILESDIR}/${PN}-2.7.2-py314.patch"
)

distutils_enable_sphinx doc

python_test() {
	cp testtools/tests/__init__.py test_suite.py || die
	if ! has_version "dev-python/twisted[${PYTHON_USEDEP}]"; then
		sed -i -e '/twistedsupport/d' test_suite.py || die
	fi

	"${EPYTHON}" -m testtools.run test_suite.test_suite ||
		die "tests failed under ${EPYTHON}"
}
