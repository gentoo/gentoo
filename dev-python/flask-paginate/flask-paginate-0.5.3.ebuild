# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )

inherit distutils-r1

MY_COMMIT="510ad833106134711868653fb597bf75ea8ac34f"

DESCRIPTION="Pagination support for flask"
HOMEPAGE="https://flask-paginate.readthedocs.io"
SRC_URI="https://github.com/lixxu/flask-paginate/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
#SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/flask[${PYTHON_USEDEP}]"

S="${WORKDIR}/${PN}-${MY_COMMIT}"

python_test() {
	pytest -vv tests/tests.py || die "tests failed with ${EPYTHON}"
}
