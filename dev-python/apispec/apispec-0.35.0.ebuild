# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{5,6} )

inherit distutils-r1

DESCRIPTION="A pluggable API specification generator."
HOMEPAGE="https://github.com/marshmallow-code/apispec/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/pyyaml-3.10[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/bottle[${PYTHON_USEDEP}]
		dev-python/marshmallow[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

src_prepare() {
	rm tests/test_swagger.py || die
	distutils-r1_src_prepare
}

python_test() {
	py.test -v || die "tests failed under ${EPYTHON}"
}
