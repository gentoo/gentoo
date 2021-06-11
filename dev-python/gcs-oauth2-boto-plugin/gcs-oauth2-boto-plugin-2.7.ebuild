# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="OAuth 2.0 plugin for Google Cloud Storage credentials in the Boto library"
HOMEPAGE="https://pypi.org/project/gcs-oauth2-boto-plugin/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

# Keep versions in sync with setup.py.
BDEPEND="
	test? ( dev-python/freezegun[${PYTHON_USEDEP}] )
"
RDEPEND="${PYTHON_DEPS}
	>=dev-python/boto-2.29.1[${PYTHON_USEDEP}]
	>=dev-python/google-reauth-python-0.1.0[${PYTHON_USEDEP}]
	>=dev-python/httplib2-0.18[${PYTHON_USEDEP}]
	>=dev-python/oauth2client-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.13[${PYTHON_USEDEP}]
	>=dev-python/retry-decorator-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.12.0[${PYTHON_USEDEP}]
"

python_prepare_all() {
	distutils-r1_python_prepare_all
	# Make sure the unittests aren't installed.
	mv gcs_oauth2_boto_plugin/test_oauth2_client.py ./ || die
}

python_test() {
	"${EPYTHON}" "${S}"/test_oauth2_client.py -v \
		|| die "tests failed with ${EPYTHON}"
}
