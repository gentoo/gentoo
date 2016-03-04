# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="command line tool for interacting with cloud storage services"
HOMEPAGE="https://github.com/GoogleCloudPlatform/gsutil"
SRC_URI="http://commondatastorage.googleapis.com/pub/${PN}_${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	>=dev-python/boto-2.22.1[${PYTHON_USEDEP}]
	>=dev-python/crcmod-1.7
	>=dev-python/httplib2-0.8[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.13[${PYTHON_USEDEP}]
	>=dev-python/google-api-python-client-1.1[${PYTHON_USEDEP}]
	>=dev-python/python-gflags-2.0[${PYTHON_USEDEP}]
	>=dev-python/retry-decorator-1.0.0[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/PySocks-1.01[${PYTHON_USEDEP}]
	"

S=${WORKDIR}/${PN}

DOCS=( README.md CHANGES.md )

PATCHES=(
	"${FILESDIR}/${P}-use-friendy-version-checks.patch"
	"${FILESDIR}/${PN}-3.37-drop-http_proxy-clearing.patch"
)

python_prepare_all() {
	sed \
		-e '/SocksiPy-branch/d' \
		-i setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	export BOTO_CONFIG=${FILESDIR}/dummy.boto
	${PYTHON} gslib/__main__.py test -u || die "tests failed"
}
