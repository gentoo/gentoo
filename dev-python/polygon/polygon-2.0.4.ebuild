# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* 2.5-jython"

inherit distutils

DESCRIPTION="Python package to handle polygonal shapes in 2D"
HOMEPAGE="http://www.j-raedler.de/projects/polygon/"
SRC_URI="mirror://github/jraedler/Polygon2/Polygon-${PV}.zip"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}/Polygon-${PV}"

src_test() {
	testing() {
		PYTHONPATH="$(dir -d build-${PYTHON_ABI}/lib*)" "$(PYTHON)" test/Test.py
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install
	dodoc HISTORY doc/Polygon.txt
}
