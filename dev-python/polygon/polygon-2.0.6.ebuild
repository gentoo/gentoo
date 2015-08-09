# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python package to handle polygonal shapes in 2D"
HOMEPAGE="http://www.j-raedler.de/projects/polygon/"
SRC_URI="https://www.bitbucket.org/jraedler/${PN}2/downloads/Polygon2-${PV}.zip"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="app-arch/unzip"

S=${WORKDIR}/Polygon2-${PV}

DOCS=( HISTORY doc/Polygon.txt )

python_test() {
	${PYTHON} test/Test.py || die "Tests failed"
}
