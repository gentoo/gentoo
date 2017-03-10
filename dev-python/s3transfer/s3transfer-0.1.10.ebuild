# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 python3_5 )
inherit distutils-r1

DESCRIPTION="An Amazon S3 Transfer Manager"
HOMEPAGE="https://github.com/boto/s3transfer"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

CDEPEND="
	>=dev-python/botocore-1.3.0[${PYTHON_USEDEP}]
	<dev-python/botocore-2.0.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '>=dev-python/futures-2.2.0[${PYTHON_USEDEP}]' 'python2_7')
	$(python_gen_cond_dep '<dev-python/futures-4.0.0[${PYTHON_USEDEP}]' 'python2_7')
"
# Pin mock to 1.3.0 if testing failures due to mock occur.
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${CDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)
"
RDEPEND="${CDEPEND}"

python_test() {
	nosetests tests/unit/ tests/functional/ || die "tests failed under ${EPYTHON}"
}
