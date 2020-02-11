# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7,8} )

inherit distutils-r1

DESCRIPTION="Python client for Sentry"
HOMEPAGE="https://getsentry.com https://pypi.org/project/sentry-sdk/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	dev-python/urllib3
	dev-python/certifi
"

python_test() {
	cd "${S}"/src || die
	"${PYTHON}" test_typing.py || die "tests failed under ${EPYTHON}"
}
