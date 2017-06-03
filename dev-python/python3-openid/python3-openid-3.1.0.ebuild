# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="Python 3 port of the python-openid library"
HOMEPAGE="https://github.com/necaris/python3-openid https://pypi.python.org/pypi/python3-openid"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/defusedxml[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? (
		dev-python/psycopg:2[${PYTHON_USEDEP}]
	)
"

python_test() {
	${EPYTHON} -m unittest -v openid.test.test_suite || die "Tests failed with ${EPYTHON}"
}
