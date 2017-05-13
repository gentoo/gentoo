# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy )

inherit distutils-r1

EGIT_COMMIT="607e86011141e8885b1f52826d57c8b5ff588ffc"
MY_PN=google-auth-library-python-httplib2
DESCRIPTION="httplib2 Transport for Google Auth"
HOMEPAGE="https://pypi.python.org/pypi/google-auth-httplib2 https://github.com/GoogleCloudPlatform/google-auth-library-python-httplib2"
# PyPi tarball is missing unit tests
#SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
SRC_URI="https://github.com/GoogleCloudPlatform/google-auth-library-python-httplib2/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"

RDEPEND="
	dev-python/httplib2[${PYTHON_USEDEP}]
	dev-python/google-auth[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	test? (
		dev-python/flask[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-localserver[${PYTHON_USEDEP}]
	)"

S=${WORKDIR}/${MY_PN}-${EGIT_COMMIT}

python_test() {
	py.test -v || die "Tests failed under ${EPYTHON}"
}
