# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

MY_P="${P/_p/.post}"

DESCRIPTION="Library for OAuth version 1.0"
HOMEPAGE="https://pypi.org/project/oauth2/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86 ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/httplib2[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest-runner[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

# https://github.com/joestump/python-oauth2/pull/212
PATCHES=( "${FILESDIR}/${PV}-exclude-tests.patch" )
S="${WORKDIR}/${MY_P}"

python_test() {
	# Skip tests which require network access
	py.test -k "not (test_access_token_post or test_access_token_get \
		or test_two_legged_post or test_two_legged_get)" || die \
		"tests failed with ${EPYTHON}"
}
