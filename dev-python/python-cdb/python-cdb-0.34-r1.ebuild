# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A Python extension module for cdb"
SRC_URI="http://pilcrow.madison.wi.us/python-cdb/${P}.tar.gz"
HOMEPAGE="http://pilcrow.madison.wi.us/#pycdb"

SLOT="0"
IUSE=""
LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos"

DEPEND="|| ( dev-db/cdb dev-db/tinycdb )"
RDEPEND="${DEPEND}"

python_test() {
	"${PYTHON}" setup.py build -b "build-${PYTHON_ABI}" install --home "${T}/test-${PYTHON_ABI}" || return 1
	# This is not really intended as test but it is better than nothing.
	"${PYTHON}" < Example
}
