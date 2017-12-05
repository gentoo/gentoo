# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="Easy, clean, reliable Python 2/3 compatibility"
HOMEPAGE="http://python-future.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 hppa x86"
IUSE=""

PATCHES=( "${FILESDIR}/${P}-fix-py35-test-failures.patch" )

python_test() {
	esetup.py test || die
}
