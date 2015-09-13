# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils

DESCRIPTION="TLS Lite is a free python library that implements SSL 3.0 and TLS 1.0/1.1"
HOMEPAGE="http://trevp.net/tlslite/ https://pypi.python.org/pypi/tlslite https://github.com/trevp/tlslite"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
#Refrain for now setting IUSE test and deps of test given test restricted.
IUSE="doc"

DEPEND="
	>=dev-libs/cryptlib-3.3.3[python,${PYTHON_USEDEP}]
	|| (
		dev-python/m2crypto[${PYTHON_USEDEP}]
		dev-python/pycrypto[${PYTHON_USEDEP}]
	)"
RDEPEND="${DEPEND}"

RESTRICT="test"

# Tests still hang
python_test() {
	cd tests || die
	"${PYTHON}" "${S}"/tests/tlstest.py client localhost:4443 . || die
	"${PYTHON}" "${S}"/tests/tlstest.py server localhost:4442 . || die
}

python_install_all(){
	use doc && HTML_DOCS=( docs/. )
	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature "GMP support" dev-python/gmpy
}
