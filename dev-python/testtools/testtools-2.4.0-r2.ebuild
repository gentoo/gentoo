# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Extensions to the Python standard library unit testing framework"
HOMEPAGE="https://github.com/testing-cabal/testtools"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"

RDEPEND="
	>=dev-python/extras-1.0.0[${PYTHON_USEDEP}]
	dev-python/python-mimeparse[${PYTHON_USEDEP}]
	>=dev-python/pbr-0.11[${PYTHON_USEDEP}]
	dev-python/pyrsistent[${PYTHON_USEDEP}]
	>=dev-python/six-1.4.0[${PYTHON_USEDEP}]
"
DEPEND="
	test? (
		>=dev-python/fixtures-1.3.0[${PYTHON_USEDEP}]
		dev-python/testscenarios[${PYTHON_USEDEP}]
	)
"
PDEPEND=">=dev-python/fixtures-1.3.0[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/testtools-2.4.0-py39.patch
	"${FILESDIR}"/testtools-2.4.0-py310.patch
	"${FILESDIR}"/testtools-2.4.0-assertitemsequal.patch
)

distutils_enable_sphinx doc
distutils_enable_tests unittest

src_prepare() {
	# eliminate unittest2 & traceback2
	sed -i -e '/unittest2/d' -e '/traceback2/d' requirements.txt || die
	# eliminate linecache2
	sed -i -e 's/import linecache2 as linecache/import linecache/' \
		testtools/tests/test_compat.py || die

	# also conditional imports
	find -name '*.py' -exec \
		sed -i -e 's:unittest2:unittest:' {} + || die
	sed -i -e 's/^traceback =.*/import traceback/' \
		testtools/content.py || die
	# py3.10 changed the output
	sed -i -e 's:test_syntax_error:_&:' \
		testtools/tests/test_testresult.py || die
	distutils-r1_src_prepare
}

python_test() {
	"${PYTHON}" -m testtools.run testtools.tests.test_suite ||
		die "tests failed under ${EPYTHON}"
}
