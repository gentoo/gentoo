# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="OAuth 2.0 plugin for Google Cloud Storage credentials in the Boto library"
HOMEPAGE="https://pypi.python.org/pypi/gcs-oauth2-boto-plugin"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"
# The tests only work with py2 atm.
RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${PN}-1.13-use-friendy-version-checks.patch"
	"${FILESDIR}/${PN}-1.13-py3.patch"
)

# Keep versions in sync with setup.py.
DEPEND="${PYTHON_DEPS}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/freezegun[${PYTHON_USEDEP}]
	)"
RDEPEND="${PYTHON_DEPS}
	>=dev-python/boto-2.29.1[${PYTHON_USEDEP}]
	>=dev-python/httplib2-0.8[${PYTHON_USEDEP}]
	>=dev-python/oauth2client-1.5.2[${PYTHON_USEDEP}]
	!=dev-python/oauth2client-2.0*
	>=dev-python/pyopenssl-0.13[${PYTHON_USEDEP}]
	>=dev-python/retry-decorator-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/PySocks-1.01[${PYTHON_USEDEP}]
	>=dev-python/six-1.6.1[${PYTHON_USEDEP}]"

python_prepare_all() {
	distutils-r1_python_prepare_all
	sed -i \
		-e '/SocksiPy-branch/d' \
		setup.py || die
	# Make sure the unittests aren't installed.
	mv gcs_oauth2_boto_plugin/test_oauth2_client.py ./ || die
}

python_test() {
	${EPYTHON} "${S}"/test_oauth2_client.py || die
}
