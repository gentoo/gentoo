# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/ipaddr/ipaddr-2.1.11.ebuild,v 1.6 2015/02/01 13:41:51 ago Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Python IP address manipulation library"
HOMEPAGE="http://code.google.com/p/ipaddr-py/ http://pypi.python.org/pypi/ipaddr"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DOCS=( README RELEASENOTES )

DISTUTILS_IN_SOURCE_BUILD=1

python_prepare() {
	if python_is_python3; then
		2to3 -n -w --no-diffs *.py || die
	fi
}

python_test() {
	PYTHONPATH=build/lib \
		"${PYTHON}" ipaddr_test.py || die "Tests fail with ${EPYTHON}"
}
