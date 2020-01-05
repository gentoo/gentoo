# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1 eutils

DESCRIPTION="TLS Lite is a free python library that implements SSL 3.0 and TLS 1.0/1.1"
HOMEPAGE="http://trevp.net/tlslite/ https://pypi.org/project/tlslite/ https://github.com/trevp/tlslite"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD public-domain"
SLOT="0"
KEYWORDS="amd64 ppc x86"
#Refrain for now setting IUSE test and deps of test given test restricted.
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

RESTRICT="test"

# Tests still hang
python_test() {
	cd tests || die
	"${PYTHON}" "${S}"/tests/tlstest.py client localhost:4443 . || die
	"${PYTHON}" "${S}"/tests/tlstest.py server localhost:4442 . || die
}

pkg_postinst() {
	optfeature "GMP support" dev-python/gmpy
}
