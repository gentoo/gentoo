# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_5,3_6} )

inherit distutils-r1

DESCRIPTION="A cached-property for decorating methods in classes"
HOMEPAGE="https://github.com/pydanny/cached-property"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? (
		dev-python/pytest
		dev-python/freezegun
		)"
RDEPEND=""

src_install() {
	distutils-r1_src_install
	dodoc README.rst HISTORY.rst CONTRIBUTING.rst AUTHORS.rst
}

python_test() {
	py.test || die
}
