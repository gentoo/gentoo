# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

MY_P="${P/_p/.post}"

DESCRIPTION="Library for OAuth version 1.0"
HOMEPAGE="https://pypi.org/project/oauth2/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86 ~x64-macos"

RDEPEND="dev-python/httplib2[${PYTHON_USEDEP}]"
DEPEND="
	test? ( ${RDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
	)"

# https://github.com/joestump/python-oauth2/pull/212
PATCHES=(
	"${FILESDIR}/${PV}-exclude-tests.patch"
)

distutils_enable_tests pytest

python_test() {
	# Skip tests which require network access
	py.test -k "not (test_access_token_post or test_access_token_get \
		or test_two_legged_post or test_two_legged_get)" || die \
		"tests failed with ${EPYTHON}"
}
