# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4,3_5} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="encoder, decoder, and lint/validator for JSON (JavaScript Object Notation) compliant with RFC 4627"
HOMEPAGE="http://deron.meranda.us/python/demjson/ https://pypi.org/project/demjson"
SRC_URI="http://deron.meranda.us/python/${PN}/dist/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
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
