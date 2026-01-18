# Copyright 2019-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="An XML Schema validator and decoder"
HOMEPAGE="
	https://github.com/sissaschool/xmlschema/
	https://pypi.org/project/xmlschema/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	<dev-python/elementpath-6[${PYTHON_USEDEP}]
	>=dev-python/elementpath-5.1.0[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools-77[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/jinja2[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
	)
"

python_test() {
	"${EPYTHON}" tests/run_all_tests.py -v || die "Tests fail with ${EPYTHON}"
}
