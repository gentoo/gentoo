# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# In Python 3.4, pathlib is now part of the standard library.
PYTHON_COMPAT=( python2_7 pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Object-oriented filesystem paths"
HOMEPAGE="https://pathlib.readthedocs.org/"
SRC_URI="mirror://pypi/p/pathlib/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ia64 x86"
IUSE=""

python_test() {
	"${PYTHON}" test_pathlib.py || die
}
