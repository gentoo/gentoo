# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/tlslite/tlslite-0.4.3-r1.ebuild,v 1.7 2015/04/08 08:05:26 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

DESCRIPTION="TLS Lite is a free python library that implements SSL 3.0 and TLS 1.0/1.1"
HOMEPAGE="http://trevp.net/tlslite/ http://pypi.python.org/pypi/tlslite"
SRC_URI="http://github.com/trevp/tlslite/downloads/${P}.tar.gz"

LICENSE="BSD public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
#Refrain for now setting IUSE test and deps of test given test restricted.
IUSE="doc gmp"
RESTRICT="test"

DEPEND=">=dev-libs/cryptlib-3.3.3[python,${PYTHON_USEDEP}]
	|| (
		dev-python/m2crypto[${PYTHON_USEDEP}]
		dev-python/pycrypto[${PYTHON_USEDEP}]
	)
	gmp? ( dev-python/gmpy[${PYTHON_USEDEP}] )"
RDEPEND="${DEPEND}"

# Tests still hang
python_test() {
	"${S}"/tests/tlstest.py client localhost:4443 .
	"${S}"/tests/tlstest.py server localhost:4442 .
}

python_install_all(){
	distutils-r1_python_install_all
	use doc && dohtml -r docs/
}
