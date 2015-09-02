# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 flag-o-matic

DESCRIPTION="Python interface to PROJ.4 library"
HOMEPAGE="https://github.com/jswhit/pyproj"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="doc"

python_prepare_all() {
	distutils-r1_python_prepare_all
	append-cflags -fno-strict-aliasing
}

python_test() {
	einfo "Testruns do not have regular unittest type tests, instead for test.py,"
	einfo "the output need be compared with a separate file, sample.out."
	"${PYTHON}" test/test.py || die

	einfo ""; einfo "Now the file test2.py is run to test pickling"; einfo ""
	"${PYTHON}" test/test2.py || die
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/. )
	distutils-r1_python_install_all
}
