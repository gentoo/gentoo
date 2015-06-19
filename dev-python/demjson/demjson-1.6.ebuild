# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/demjson/demjson-1.6.ebuild,v 1.3 2011/05/27 10:41:55 phajdan.jr Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="encoder, decoder, and lint/validator for JSON (JavaScript Object Notation) compliant with RFC 4627"
HOMEPAGE="http://deron.meranda.us/python/demjson/ http://pypi.python.org/pypi/demjson"
SRC_URI="http://deron.meranda.us/python/${PN}/dist/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

DEPEND="dev-python/setuptools"
RDEPEND=""

DOCS="AUTHORS.txt CHANGES.txt NEWS.txt THANKS.txt docs/*.txt"
PYTHON_MODNAME="demjson.py"

src_test() {
	cd test

	testing() {
		PYTHONPATH="../build-${PYTHON_ABI}/lib" "$(PYTHON)" test_demjson.py
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	if use doc; then
		dohtml docs/*.html || die "Installation of documentation failed"
	fi
}
