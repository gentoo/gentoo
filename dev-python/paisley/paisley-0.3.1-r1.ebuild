# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A CouchDB client written in Python to be used within a Twisted application"
HOMEPAGE="https://launchpad.net/paisley https://pypi.org/project/paisley/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/simplejson[${PYTHON_USEDEP}]
	dev-python/twisted-core[${PYTHON_USEDEP}]
	dev-python/twisted-web[${PYTHON_USEDEP}]"
DEPEND="test? ( ${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}] )"

python_test() {
	nosetests || die "tests failed"
}
