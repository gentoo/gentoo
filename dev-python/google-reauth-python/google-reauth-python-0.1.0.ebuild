# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Python based U2F host library"
HOMEPAGE="https://github.com/google/google-reauth-python"
SRC_URI="https://github.com/google/google-reauth-python/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/oauth2client[${PYTHON_USEDEP}]
	dev-python/pyu2f[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

DOCS=( CHANGELOG.rst CONTRIBUTING.rst README.rst )

python_prepare_all() {
	sed -e "s:'some_origin'.encode('ascii'):'some_origin':" \
		-e "s:SignResponse('key_handle', 'resp',:SignResponse('key_handle'.encode(), 'resp'.encode(),:" \
		-i tests/test_reauth.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	py.test -v tests || die "Tests failed under ${EPYTHON}"
}
