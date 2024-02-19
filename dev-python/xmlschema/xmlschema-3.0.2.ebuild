# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="An XML Schema validator and decoder"
HOMEPAGE="
	https://github.com/sissaschool/xmlschema/
	https://pypi.org/project/xmlschema/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	<dev-python/elementpath-5[${PYTHON_USEDEP}]
	>=dev-python/elementpath-4.3.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
		dev-python/jinja[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
	)
"

python_test() {
	"${EPYTHON}" tests/test_all.py -v || die "Tests fail with ${EPYTHON}"
}
