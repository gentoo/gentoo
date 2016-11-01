# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} pypy )

inherit distutils-r1

DESCRIPTION="A simple serialization library based on ast.literal_eval"
HOMEPAGE="https://pypi.python.org/pypi/serpent https://github.com/irmen/Serpent"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc ~ppc64 x86"
IUSE=""

# not bundled
RESTRICT="test"

python_test() {
	${PYTHON} -bb test_serpent.py || die
}
