# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Python IP address manipulation library"
HOMEPAGE="https://code.google.com/p/ipaddr-py/ https://pypi.python.org/pypi/ipaddr"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86 arm"
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
