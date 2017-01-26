# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_{4,5}} )

inherit distutils-r1

DESCRIPTION="Spec-compliant and thorough implementation of the OAuth request-signing logic"
HOMEPAGE="https://github.com/idan/oauthlib https://pypi.python.org/pypi/oauthlib"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="test"

# optional extras hard set as RDEPs. See setup.py
RDEPEND="
	dev-python/pycrypto[${PYTHON_USEDEP}]
	>=dev-python/pyjwt-1.0.0[${PYTHON_USEDEP}]
	dev-python/blinker[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '>=dev-python/mock-1.0.1[${PYTHON_USEDEP}]' python2_7)
		$(python_gen_cond_dep 'dev-python/unittest2[${PYTHON_USEDEP}]' python2_7) )
	"

python_test() {
	nosetests || die "tests failed under ${EPYTHON}"
}
