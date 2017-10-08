# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
inherit distutils-r1

DESCRIPTION="Stripe python bindings"
HOMEPAGE="https://github.com/stripe/stripe-python"
SRC_URI="mirror://pypi/s/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-python/requests-0.8.8"
DEPEND="${RDEPEND}
	test? (
		dev-python/unittest2
		dev-python/mock
		dev-python/pycurl
		)"

DOCS="CHANGELOG LONG_DESCRIPTION.rst README.md"

python_test() {
	${PYTHON:-python} -Wall setup.py test || die
}
