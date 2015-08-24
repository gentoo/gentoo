# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="SNMP framework in Python. Not a wrapper"
HOMEPAGE="http://pysnmp.sf.net/ https://pypi.python.org/pypi/pysnmp"
SRC_URI="mirror://sourceforge/pysnmp/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

DOCS="CHANGES COMPATIBILITY README"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_install(){
	distutils-r1_src_install

	dohtml -r docs/
	insinto /usr/share/doc/${PF}
	doins -r examples
}
