# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1

DESCRIPTION="A generic, spec-compliant, thorough implementation of the OAuth request-signing logic"
HOMEPAGE="https://github.com/idan/oauthlib https://pypi.python.org/pypi/oauthlib"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="test"

# optional extras hard set as RDEPs. See setup.py
RDEPEND="dev-python/pycrypto[${PYTHON_USEDEP}]
		dev-python/pyjwt[${PYTHON_USEDEP}]
		dev-python/blinker[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '>=dev-python/mock-1.0.1[${PYTHON_USEDEP}]' python2_7)
	)"

python_test() {
	nosetests || die "tests failed under ${EPYTHON}"
}
