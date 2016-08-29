# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

# Python 3: https://github.com/GoogleCloudPlatform/gcs-oauth2-boto-plugin/issues/10
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="OAuth 2.0 plugin for Google Cloud Storage credentials in the Boto library"
HOMEPAGE="https://pypi.python.org/pypi/gcs-oauth2-boto-plugin"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

PATCHES=(
	"${FILESDIR}/${PN}-1.12-use-friendy-version-checks.patch"
)

# Keep versions in sync with setup.py.
DEPEND="${PYTHON_DEPS}
	dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${PYTHON_DEPS}
	>=dev-python/boto-2.29.1[${PYTHON_USEDEP}]
	>=dev-python/httplib2-0.8[${PYTHON_USEDEP}]
	>=dev-python/oauth2client-1.5.2[${PYTHON_USEDEP}]
	!=dev-python/oauth2client-2*
	>=dev-python/pyopenssl-0.13[${PYTHON_USEDEP}]
	>=dev-python/retry-decorator-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/PySocks-1.01[${PYTHON_USEDEP}]"

python_prepare_all() {
	distutils-r1_python_prepare_all
	sed \
		-e '/SocksiPy-branch/d' \
		-i setup.py || die
}
