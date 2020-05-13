# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

EGIT_COMMIT="e7cd722281d1d897fa9ae6e3b6b78ae142778e6e"
MY_PN="google-auth-library-python-httplib2"
DESCRIPTION="httplib2 Transport for Google Auth"
HOMEPAGE="https://pypi.org/project/google-auth-httplib2/ https://github.com/GoogleCloudPlatform/google-auth-library-python-httplib2"
# PyPi tarball is missing unit tests
#SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
SRC_URI="https://github.com/GoogleCloudPlatform/google-auth-library-python-httplib2/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

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

S="${WORKDIR}/${MY_PN}-${EGIT_COMMIT}"

python_test() {
	pytest -vv || die "Tests failed under ${EPYTHON}"
}
