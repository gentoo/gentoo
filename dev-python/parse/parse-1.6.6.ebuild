# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="parse() is the opposite of format()"
HOMEPAGE="https://github.com/r1chardj0n3s/parse"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

PATCHES=( "${FILESDIR}/${P}-python-3.5-tests-compat.patch" )

python_test() {
	"${PYTHON}" test_parse.py || die "Tests failed under ${EPYTHON}"
}
