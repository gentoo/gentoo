# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Authentication Results Header Module"
HOMEPAGE="https://launchpad.net/authentication-results-python https://pypi.python.org/pypi/authres"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="amd64 x86"
SLOT="0"
IUSE=""

DOCS=( CHANGES README )

python_test() {
	"${PYTHON}" -c "import sys, ${PN}, doctest; f, t = doctest.testfile('${PN}/tests'); \
		sys.exit(bool(f))" || return
}
