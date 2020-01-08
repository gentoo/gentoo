# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Python based U2F host library"
HOMEPAGE="https://github.com/google/pyu2f"
# pypi tarball lacks unit tests
#SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://github.com/google/pyu2f/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pyfakefs[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/unittest2[${PYTHON_USEDEP}]
	)
"

DOCS=( CONTRIBUTING.md README.md )

python_prepare_all() {
	sed -e 's:json.loads(communicate_json):json.loads(communicate_json.decode()):' \
		-i pyu2f/tests/customauthenticator_test.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	py.test -v pyu2f/tests || die "Tests failed under ${EPYTHON}"
}
