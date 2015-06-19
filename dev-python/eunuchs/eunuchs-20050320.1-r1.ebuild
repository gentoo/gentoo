# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/eunuchs/eunuchs-20050320.1-r1.ebuild,v 1.8 2015/04/08 08:05:26 mgorny Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1 eutils

DESCRIPTION="Missing manly parts of UNIX API for Python"
HOMEPAGE="http://www.inoi.fi/open/trac/eunuchs http://pypi.python.org/pypi/python-eunuchs"
SRC_URI="mirror://debian/pool/main/e/${PN}/${PN}_${PV}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 arm ia64 x86"
IUSE=""

DEPEND=""
RDEPEND=""

PATCHES=( "${FILESDIR}/${P}-python-2.5.patch" )
DOCS=( examples/ )

python_test() {
	${PYTHON} examples/test-socketpair.py || die "Tests failed with ${EPYTHON}"
}
