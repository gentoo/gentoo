# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

HOMEPAGE="https://github.com/requests/requests-kerberos/"
DESCRIPTION="A Kerberos authentication handler for python-requests"
SRC_URI="https://github.com/requests/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-python/requests-1.1.0[${PYTHON_USEDEP}]
	|| ( >=dev-python/pykerberos-1.1.8[${PYTHON_USEDEP}] <dev-python/pykerberos-2[${PYTHON_USEDEP}] )"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/mock[${PYTHON_USEDEP}] )"

python_test() {
	${PYTHON} tests/test_requests_kerberos.py || die
}
