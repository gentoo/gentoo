# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7..9} pypy3 )

inherit distutils-r1

DESCRIPTION="An XML Schema validator and decoder"
HOMEPAGE="https://github.com/sissaschool/xmlschema https://pypi.org/project/xmlschema/"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/elementpath-2.1.2[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}
	test? (
		dev-python/jinja[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
	)"

python_test() {
	"${EPYTHON}" tests/test_all.py -v ||
		die "Tests fail with ${EPYTHON}"
}
