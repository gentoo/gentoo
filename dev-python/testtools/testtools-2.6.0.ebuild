# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 pypi

DESCRIPTION="Extensions to the Python standard library unit testing framework"
HOMEPAGE="
	https://github.com/testing-cabal/testtools/
	https://pypi.org/project/testtools/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/python-mimeparse[${PYTHON_USEDEP}]
	>=dev-python/pbr-0.11[${PYTHON_USEDEP}]
	dev-python/pyrsistent[${PYTHON_USEDEP}]
	>=dev-python/six-1.4.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/fixtures-2.0.0[${PYTHON_USEDEP}]
		dev-python/testscenarios[${PYTHON_USEDEP}]
	)
"
PDEPEND="
	>=dev-python/fixtures-2.0.0[${PYTHON_USEDEP}]
"

distutils_enable_sphinx doc

src_prepare() {
	# very fragile to formatting changes (broken on py3.10 & pypy3)
	sed -i -e 's:test_syntax_error(:_&:' \
		testtools/tests/test_testresult.py || die

	distutils-r1_src_prepare
}

python_test() {
	"${PYTHON}" -m testtools.run testtools.tests.test_suite ||
		die "tests failed under ${EPYTHON}"
}
