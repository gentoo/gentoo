# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} )
inherit distutils-r1

DESCRIPTION="An XML Schema validator and decoder"
HOMEPAGE="https://github.com/sissaschool/xmlschema https://pypi.org/project/xmlschema/"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/elementpath[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/lxml[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/pathlib2[${PYTHON_USEDEP}]' -2)
	)"

python_test() {
	"${EPYTHON}" xmlschema/tests/test_all.py -v ||
		die "Tests fail with ${EPYTHON}"
}
