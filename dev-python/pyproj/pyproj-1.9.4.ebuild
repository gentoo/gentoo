# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyproj/pyproj-1.9.4.ebuild,v 1.1 2015/06/24 07:44:40 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python interface to PROJ.4 library"
HOMEPAGE="http://github.com/jswhit/pyproj"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="doc"

CFLAGS="${CFLAGS} -fno-strict-aliasing"

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
