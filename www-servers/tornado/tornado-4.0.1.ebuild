# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Python web framework and asynchronous networking library"
HOMEPAGE="http://www.tornadoweb.org/ https://pypi.python.org/pypi/tornado"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm hppa ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="curl test"

RDEPEND="
	curl? ( $(python_gen_cond_dep 'dev-python/pycurl[${PYTHON_USEDEP}]' python2_7) )
	dev-python/certifi[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/backports-ssl-match-hostname[${PYTHON_USEDEP}]' python2_7 pypy)"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7 pypy)
		$(python_gen_cond_dep 'dev-python/twisted-names[${PYTHON_USEDEP}]' python2_7)
		dev-python/service_identity[${PYTHON_USEDEP}]
	)"

python_test() {
	"${PYTHON}" -m tornado.test.runtests || die "Tests fail with ${EPYTHON}"
}
