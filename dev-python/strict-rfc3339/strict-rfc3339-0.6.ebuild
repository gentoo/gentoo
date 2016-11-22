# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Strict, simple, lightweight RFC3339 functions"
HOMEPAGE="https://pypi.python.org/pypi/strict-rfc3339 https://github.com/danielrichman/strict-rfc3339"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3+"
KEYWORDS="alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ppc64 ~s390 ~sh ~sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

# Not shipped
RESTRICT=test

python_test() {
	${PYTHON} test_strict_rfc3339.py || die
}
