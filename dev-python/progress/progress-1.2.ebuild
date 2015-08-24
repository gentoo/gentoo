# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} pypy pypy3  )

inherit bash-completion-r1 distutils-r1

DESCRIPTION="Easy to use progress bars"
HOMEPAGE="https://pypi.python.org/pypi/progress https://github.com/verigak/progress/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="ISC"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

# Not bundled
RESTRICT="test"

python_test() {
	"${PYTHON}" test_progress.py || die
}
