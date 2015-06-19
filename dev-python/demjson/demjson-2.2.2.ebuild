# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/demjson/demjson-2.2.2.ebuild,v 1.3 2014/12/28 10:07:07 ago Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="encoder, decoder, and lint/validator for JSON (JavaScript Object Notation) compliant with RFC 4627"
HOMEPAGE="http://deron.meranda.us/python/demjson/ http://pypi.python.org/pypi/demjson"
SRC_URI="http://deron.meranda.us/python/${PN}/dist/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

python_test() {
	cd test
	if python_is_python3; then
		2to3 -w --no-diffs test_demjson.py
	fi
	"${PYTHON}" test_demjson.py
}

python_install_all() {
	distutils-r1_python_install_all
	# Docs are .txt files
	if use doc; then
		dodoc docs/*.txt || die "Installation of documentation failed"
	fi
}
