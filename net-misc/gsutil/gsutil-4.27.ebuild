# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

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

# The oauth2client-2 dep sucks.
# https://github.com/GoogleCloudPlatform/gsutil/issues/355
RDEPEND="${PYTHON_DEPS}
	>=dev-python/argcomplete-1.8.2[${PYTHON_USEDEP}]
	>=dev-python/boto-2.47.0[${PYTHON_USEDEP}]
	>=dev-python/crcmod-1.7[${PYTHON_USEDEP}]
	>=dev-python/httplib2-0.8[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.13[${PYTHON_USEDEP}]
	>=dev-python/gcs-oauth2-boto-plugin-1.14[${PYTHON_USEDEP}]
	>=dev-python/google-apitools-0.5.3[${PYTHON_USEDEP}]
	=dev-python/oauth2client-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/python-gflags-2.0[${PYTHON_USEDEP}]
	>=dev-python/retry-decorator-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/PySocks-1.01[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S=${WORKDIR}/${PN}

DOCS=( README.md CHANGES.md )

PATCHES=(
	"${FILESDIR}"/${PN}-4.27-use-friendy-version-checks.patch
)

python_prepare_all() {
	distutils-r1_python_prepare_all
	sed -i \
		-e '/SocksiPy-branch/d' \
		setup.py || die

	# Package installs 'test' package which is forbidden and likely a bug in the build system
	rm -rf "${S}/test" || die
	sed -i -e '/recursive-include test/d' MANIFEST.in || die
}

python_test() {
	export BOTO_CONFIG=${FILESDIR}/dummy.boto
	${PYTHON} gslib/__main__.py test -u || die "tests failed"
}
